# require "pry"
source_paths.unshift(File.dirname(__FILE__))

APPLICATION_RB = <<-'APPLICATION_RB'
    config.generators do |g|
      g.assets                    false
      g.lasha_assets              true
      g.helper                    false
      # g.test_framework            nil
      g.system_tests              nil
      g.jbuilder                  false
      g.lasha_scaffold_controller true
    end

    config.api_only_mode = ActiveModel::Type::Boolean.new.cast(ENV["API_ONLY_MODE"])

    config.i18n.default_locale = :en
    config.i18n.available_locales = [:ka, :en]
    config.i18n.fallbacks = [en: :ka, ka: :en]

    config.sass.preferred_syntax = :sass
    config.generators.javascript_engine = :js

    config.active_job.queue_adapter = :sidekiq
    config.active_job.queue_name_prefix = "#{ENV['RAILS_APP_NAME']}_#{Rails.env}"

    config.action_mailer.delivery_method = :sendgrid_actionmailer
    config.action_mailer.sendgrid_actionmailer_settings = {
      api_key: Rails.application.credentials[:sendgrid_key],
      raise_delivery_errors: true
    }

    config.action_mailer.default_url_options = {
      host: Rails.application.credentials.dig(Rails.env.to_sym, :host)
    }

    config.action_cable.allowed_request_origins = [
      "https://#{Rails.application.credentials.dig(Rails.env.to_sym, :host)}",
      /https:\/\/#{Rails.application.credentials.dig(Rails.env.to_sym, :host)}.*/
    ]

    config.cache_store = :redis_cache_store, {
      expires_in: 1.hour,
      driver: :hiredis,
      url: ENV.fetch("REDISCLOUD_IVORY_URL") { ENV.fetch("REDIS_URL") { "redis://localhost:6379" } }
    }

    config.eager_load_paths << Rails.root.join("lib", "modules")

    config.middleware.insert 0, Rack::UTF8Sanitizer
APPLICATION_RB

APPLICATION_JS = <<~APPLICATION_JS
  window.alertify = require("alertifyjs")
  window.PhotoSwipe = require("photoswipe/dist/photoswipe.min")
  window.PhotoSwipeUI_Default = require("photoswipe/dist/photoswipe-ui-default.min")
  window.autosize = require("autosize/dist/autosize.min.js")
  require("modules/photo-swipe-dom-initializer")
  import BSN from "bootstrap.native/dist/bootstrap-native.esm.min.js";

  document.addEventListener("turbolinks:load", function() {
    BSN.initCallback(document.body);
    // helpers.fadeOutEffectAndHide(document.getElementById("before-page-spinner"));

    autosize(document.querySelectorAll("textarea"));

    // initPhotoSwipeFromDOM(".thumbnail-list-wrapper");
  });
APPLICATION_JS

########################################################################
############################ HELPER METHODS ############################
def inject_text_after(filename, comment, after)
  inject_into_file filename, after: "#{after}\n" do
    <<~RUBY
      #{comment}
    RUBY
  end
end

def inject_text_before(filename, comment, before)
  inject_into_file filename, before: "#{before}\n" do
    <<~RUBY
      #{comment}
    RUBY
  end
end

def rework_application_rb
  inject_into_file "config/application.rb", APPLICATION_RB, after: "# the framework and any gems in your application.\n\n"
  gsub_file "config/application.rb", "# Don't generate system test files.", ""
  gsub_file "config/application.rb", "config.generators.system_tests = nil", ""
end

def rework_application_js
  inject_into_file "app/javascript/packs/application.js", APPLICATION_JS
end

def rework_gemfile
  # remove sass-rails in favor of sassc-rails
  gsub_file "Gemfile", /^# Use SCSS for stylesheets/, ''
  gsub_file "Gemfile", /^gem\s+["']sass-rails["'].*$/, ''

  # remove comments from Gemfile
  gsub_file "Gemfile", /#\s.*\n/, "\n"  # remove comments
  gsub_file "Gemfile", /\n^\s*\n/, "\n" # remove multiple spaces

  inject_text_before("Gemfile", "\n################################################################################", "gem 'lasha', path: 'lasha'")
  inject_text_before("Gemfile", "# General", "gem 'lasha', path: 'lasha'")
  inject_text_before("Gemfile", "\n# Services", "gem 'sendgrid-actionmailer'")
  inject_text_after("Gemfile", "\n# Security", "gem 'gravatar_image_tag'")
  security_commented_gems = <<~RUBY
    # gem 'devise_masquerade'
    # gem 'devise-two-factor'
    # gem 'devise_token_auth', '~> 0.2'
    # gem 'recaptcha'
  RUBY
  inject_text_after("Gemfile", security_commented_gems, "\n# Security")

  inject_text_before("Gemfile", "# Debugging & Optimization", "gem 'active_record_query_trace'")

  inject_text_after("Gemfile", "\n# I18n", "gem 'rack-utf8_sanitizer'")
  inject_text_after("Gemfile", "\n# Mechanical Line", "gem 'rails-i18n'")
  inject_text_after("Gemfile", "# gem 'globalize', github: 'globalize/globalize'", "gem 'rails-i18n'")
  inject_text_after("Gemfile", " ", "end")
end

def env_touch(environment = "development")
  filename = case environment
             when "development" then ".env"
             else ".env_#{environment}"
             end

  File.open(filename, "w") do |file|
    file.puts <<~ENV_TEMPLATE
      # DATABASE_URL="postgres://user:pass@localhost:5432/name_development"
      # API_ONLY_MODE=false
      RACK_ENV=#{environment}
      RAILS_ENV=#{environment}
      MAINTENANCE_PAGE_URL=https://s3.eu-central-1.amazonaws.com/<appname>-public-read-only/maintenance-mode.html
      RAILS_MAX_THREADS=25
      PORT=3000
    ENV_TEMPLATE
    file.puts "RAILS_MASTER_KEY=#{File.read('config/master.key')}"
    file.puts "RAILS_APP_NAME=#{Dir.pwd.split('/').last}"
  end
end

def add_gems
  gem 'lasha', path: 'lasha'

  # General
  gem 'meta-tags'
  # gem 'http'
  gem 'rest-client'
  gem 'oj'
  gem 'font-awesome-sass', '~> 5.6.1'
  gem 'paper_trail'
  gem 'notifications'
  gem "simple_calendar", "~> 2.0"

  # Services
  gem 'sendgrid-actionmailer'
  gem 'aws-sdk-s3', '~> 1'
  gem 'gravatar_image_tag'

  # Security
  # gem 'devise_masquerade'
  # gem 'devise-two-factor'
  # gem 'recaptcha'
  gem "paper_trail"

  # Debugging & Optimization
  gem 'active_record_query_trace'
  gem 'rack-utf8_sanitizer'

  # I18n
  gem 'devise-i18n'
  gem 'rails-i18n'
  # gem 'globalize', github: 'globalize/globalize'

  gem_group :development, :test do
    gem "pry-rails"
    gem "awesome_print"
    gem "rspec-rails"
    gem "factory_bot_rails", require: false
    gem "webmock", require: false
    gem "capybara"
    gem "database_cleaner"
    # gem 'shoulda-matchers'
    # gem 'rails-controller-testing'
    gem "dotenv-rails"
    gem "webdrivers"
  end

  gem_group :development, :test, :staging do
    gem "faker", "1.9.3"
    gem "bullet"
  end

  gem_group :development do
    # capistrano
    gem "capistrano",         require: false
    gem "capistrano-bundler", require: false
    gem "capistrano-rails",   require: false
    gem "capistrano-rvm",     require: false
    gem "capistrano3-puma",   require: false

    gem "derailed_benchmarks"
    gem "rails-erd", require: false
    gem "i18n-tasks", "~> 0.9.6"
    gem "i18n_generators", "~> 2.1", ">= 2.1.1"
    gem "rubocop"
    gem "rubocop-performance"
    gem "droplet_kit"
    gem "ed25519"
    gem "bcrypt_pbkdf"
    gem "mailcatcher"
  end
end

def copy_base_files
  # Procfile
  # Procfile.dev
  files_to_copy = %w[
    .gitignore
    .rubocop.yml
    .bundle/config
    Capfile
    spec/rails_helper.rb
    spec/spec_helper.rb
  ]
  dirs_to_copy = %w[app config db lasha lib]
  force_overwrite = %[.gitignore]

  files_to_copy.each { |file| copy_file file, force: force_overwrite.include?(file) }
  dirs_to_copy.each  { |dir|  directory dir, force: true }

  # touch env & move master key
  env_touch("development")
  env_touch("production")
end

def remove_base_files
  remove_file "app/assets/stylesheets/application.css"
  remove_file "app/views/layouts/application.html.erb"
  remove_file "app/views/layouts/mailer.html.erb"
  remove_file "app/views/layouts/mailer.text.erb"
  remove_file "config/master.key"
end

############################## Main Flow ###############################
########################################################################
environment "config.require_master_key = true"
environment "config.application_name = Rails.application.class.module_parent_name"
rework_application_rb

# development
environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }", env: :development
environment "# config.hosts += ['www.domain.com', 'domain.com']", env: :development
environment "# # Rails.application.credentials.send(Rails.env)[:host]", env: :development
# # mailcatcher
environment "config.action_mailer.smtp_settings = { :address => '127.0.0.1', :port => 1025 }", env: :development
environment "config.action_mailer.delivery_method = :smtp", env: :development

add_gems
rework_gemfile

copy_base_files
remove_base_files

# add yarn packages
`yarn add alertifyjs autosize bootstrap bootstrap.native lodash photoswipe`

rework_application_js

bundle_command "install"
after_bundle do
  git :init
  git add: "."
  git commit: "-a -m 'Initial commit'"

  bundle_command "exec rubocop --safe-auto-correct -c .rubocop.yml"
  git commit: "-a -m 'apply rubocop safe-auto-correct'"

  rails_command("action_text:install")
  git commit: "-a -m 'install action_text'"

  rails_command("generate paper_trail:install --with-changes")
  git commit: "-a -m 'add papertrail'"

  git remote: "add origin git@github.com:webzorg/#{Dir.pwd.split('/').last}.git"
  git remote: "-v"
  git push: "origin master"
end

rails_command("db:create")
rails_command("db:migrate")
