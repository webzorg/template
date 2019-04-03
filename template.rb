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

def nicely_format_gemfile
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
  # General
  gem 'sassc-rails'
  gem 'aasm'
  gem 'meta-tags'
  gem 'http'
  gem 'pagy'
  gem 'slim-rails'
  gem 'font-awesome-sass', '~> 5.6.1'
  gem 'autoprefixer-rails'
  gem 'paper_trail'

  # Services
  gem 'sendgrid-actionmailer'
  gem 'aws-sdk-s3', '~> 1'
  gem 'gravatar_image_tag'

  # Security
  gem 'devise'
  gem 'omniauth-facebook'
  gem 'omniauth-google-oauth2'
  gem 'rolify'
  gem 'pundit'
  # gem 'devise_masquerade'
  # gem 'devise-two-factor'
  # gem 'devise_token_auth', "~> 0.2"
  # gem 'recaptcha'

  # Debugging & Optimization
  gem 'active_record_query_trace'
  gem 'rack-utf8_sanitizer'

  # I18n
  gem 'devise-i18n'
  gem 'rails-i18n'
  # gem 'globalize', github: 'globalize/globalize'

  # Mechanical Line
  gem 'redis', '~> 4.0'
  gem 'hiredis'
  gem 'sidekiq'
  gem 'sidekiq-cron'
  gem 'sidekiq-failures'
  gem 'sitemap_generator'
  gem 'image_processing', '~> 1.2'

  gem_group :development, :test do
    gem 'awesome_print'
    gem 'rspec-rails'
    gem 'factory_bot_rails'
    gem 'capybara'
    gem 'database_cleaner'
    gem 'shoulda-matchers'
    gem 'rails-controller-testing'
  end

  gem_group :development, :test, :staging do
    gem 'faker', '1.9.3'
  end

  gem_group :development do
    gem 'derailed_benchmarks'
    gem 'rails-erd', require: false
    gem 'i18n-tasks', '~> 0.9.6'
    gem 'i18n_generators', '~> 2.1', '>= 2.1.1'
    gem 'rubocop'
  end
end

def remove_base_files
  remove_file "app/assets/stylesheets/application.css"
end

def copy_base_files
  base_path = File.join(Dir.home, "www", "template")
  files_to_copy = %w[
    .rubocop.yml
    Procfile
    Procfile.dev
    .env
    .bundle/config
  ]
  files_to_copy.each do |file|
    copy_file File.join(base_path, file), file
  end
end

############################ HELPER METHODS ############################
########################################################################

add_gems

after_bundle do
  nicely_format_gemfile

  # application name
  environment "config.application_name = Rails.application.class.parent_name"

  remove_base_files
  copy_base_files

  git :init
  git add: "."
  git commit: "-a -m 'Initial commit'"

  bundle_command "exec rubocop --auto-correct --safe-auto-correct"
end
