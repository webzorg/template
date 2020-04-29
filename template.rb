require "pry"
require "rails/generators/migration.rb"
source_paths.unshift(File.dirname(__FILE__))

APPLICATION_RB = <<-'APPLICATION_RB'
    config.generators do |g|
      g.assets            false
      g.helper            false
      # g.test_framework    nil
      g.system_tests      nil
      g.jbuilder          false
    end

    config.app_name = ENV["RAILS_APP_NAME"]
    config.api_only_mode = ActiveModel::Type::Boolean.new.cast(ENV["API_ONLY_MODE"])

    config.i18n.default_locale = :ka
    config.i18n.available_locales = [:ka, :en]
    config.i18n.fallbacks = [en: :ka, ka: :en]

    config.sass.preferred_syntax = :sass
    config.generators.javascript_engine = :js

    config.active_job.queue_adapter = :sidekiq
    config.active_job.queue_name_prefix = "#{Rails.configuration.app_name}_#{Rails.env}"

    config.action_mailer.delivery_method = :sendgrid_actionmailer
    config.action_mailer.sendgrid_actionmailer_settings = {
      api_key: Rails.application.credentials.dig(:sendgrid_key),
      raise_delivery_errors: true
    }

    config.action_mailer.default_url_options = {
      host: Rails.application.credentials.dig(Rails.env, :host)
    }

    config.action_cable.allowed_request_origins = [
      "https://#{Rails.application.credentials.dig(Rails.env, :host)}",
      /https:\/\/#{Rails.application.credentials.dig(Rails.env, :host)}.*/
    ]

    config.cache_store = :redis_cache_store, {
      expires_in: 1.hour,
      driver: :hiredis,
      url: ENV.fetch("REDISCLOUD_IVORY_URL") { ENV.fetch("REDIS_URL") { "redis://localhost:6379" } }
    }

    config.eager_load_paths << Rails.root.join("lib", "modules")

    config.middleware.insert 0, Rack::UTF8Sanitizer
APPLICATION_RB

########################################################################
############################ HELPER METHODS ############################
def inject_text_after(filename, comment, after)
  inject_into_file filename, after: "#{after}\n" do
  <<-RUBY
#{comment}
  RUBY
  end
end

def inject_text_before(filename, comment, before)
  inject_into_file filename, before: "#{before}\n" do
  <<-RUBY
#{comment}
  RUBY
  end
end

def rework_application_rb
  inject_into_file "config/application.rb", APPLICATION_RB, after: "# the framework and any gems in your application.\n\n"
  gsub_file "config/application.rb", "# Don't generate system test files.", ""
  gsub_file "config/application.rb", "config.generators.system_tests = nil", ""
end

def rework_gemfile
  # remove sass-rails in favor of sassc-rails
  gsub_file "Gemfile", /^# Use SCSS for stylesheets/, ''
  gsub_file "Gemfile", /^gem\s+["']sass-rails["'].*$/, ''

  # remove comments from Gemfile
  gsub_file "Gemfile", /#\s.*\n/, "\n"  # remove comments
  gsub_file "Gemfile", /\n^\s*\n/, "\n" # remove multiple spaces

  inject_text_before("Gemfile", "\n################################################################################", "gem 'sassc-rails'")
  inject_text_before("Gemfile", "# General", "gem 'sassc-rails'")
  inject_text_after("Gemfile", "\n# Services", "gem 'paper_trail'")
  inject_text_after("Gemfile", "\n# Security", "gem 'gravatar_image_tag'")
  security_commented_gems = "# gem 'devise_masquerade'
# gem 'devise-two-factor'
# gem 'devise_token_auth', '~> 0.2'
# gem 'recaptcha'
"
  inject_text_after("Gemfile", security_commented_gems, "gem 'pundit'")
  inject_text_before("Gemfile", "# Debugging & Optimization", "gem 'active_record_query_trace'")
  inject_text_after("Gemfile", "\n# I18n", "gem 'rack-utf8_sanitizer'")
  inject_text_after("Gemfile", "\n# Mechanical Line", "gem 'rails-i18n'")
  inject_text_after("Gemfile", "# gem 'globalize', github: 'globalize/globalize'", "gem 'rails-i18n'")
  inject_text_after("Gemfile", " ", "gem 'image_processing', '~> 1.2'")
end

def add_gems
  gem "lasha", path: "lasha"

  # General
  gem 'meta-tags'
  # gem 'http'
  gem 'rest-client'
  gem 'oj'
  gem 'font-awesome-sass', '~> 5.6.1'
  gem 'paper_trail'
  gem 'notifications'

  # Services
  gem 'sendgrid-actionmailer'
  gem 'aws-sdk-s3', '~> 1'
  gem 'gravatar_image_tag'

  # Security
  # gem 'devise_masquerade'
  # gem 'devise-two-factor'
  # gem 'recaptcha'

  # Debugging & Optimization
  gem 'active_record_query_trace'
  gem 'rack-utf8_sanitizer'

  # I18n
  gem 'devise-i18n'
  gem 'rails-i18n'
  # gem 'globalize', github: 'globalize/globalize'

  gem_group :development, :test do
    gem 'pry-rails'
    gem 'bullet'
    gem 'awesome_print'
    gem 'rspec-rails'
    gem 'factory_bot_rails'
    gem 'capybara'
    gem 'database_cleaner'
    # gem 'shoulda-matchers'
    # gem 'rails-controller-testing'
  end

  gem_group :development, :test, :staging do
    gem 'faker', '1.9.3'
  end

  gem_group :development do
    # capistrano
    gem "capistrano",         require: false
    gem "capistrano-bundler", require: false
    gem "capistrano-rails",   require: false
    gem "capistrano-rvm",     require: false
    gem "capistrano3-puma",   require: false

    gem 'derailed_benchmarks'
    gem 'rails-erd', require: false
    gem 'i18n-tasks', '~> 0.9.6'
    gem 'i18n_generators', '~> 2.1', '>= 2.1.1'
    gem 'rubocop'
    gem 'rubocop-performance'
  end
end

def remove_base_files
  remove_file "app/assets/stylesheets/application.css"
end

def copy_base_files
  files_to_copy = %w[.rubocop.yml Procfile Procfile.dev .env .bundle/config]
  dirs_to_copy = %w[app config db lasha]

  files_to_copy.each { |file| copy_file file }
  dirs_to_copy.each  { |dir|  directory dir, force: true }
end

############################## Main Flow ###############################
########################################################################
environment "config.application_name = Rails.application.class.module_parent_name"
rework_application_rb

add_gems
rework_gemfile

remove_base_files
copy_base_files

# add yarn packages
`yarn add alertifyjs autosize bootstrap bootstrap.native lodash photoswipe`

# bundle_command "install"
after_bundle do
  git :init
  git add: "."
  git commit: "-a -m 'Initial commit'"

  bundle_command "exec rubocop --safe-auto-correct"
  git commit: "-a -m 'apply rubocop safe-auto-correct'"
end

rails_command("db:create")
rails_command("db:migrate")
