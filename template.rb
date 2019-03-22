gem "aasm"
gem "meta-tags"
gem "http"
gem "pagy"
gem "slim-rails"
# gem "data-confirm-modal"
gem "font-awesome-sass", "~> 5.6.1"
gem "autoprefixer-rails"
gem "paper_trail"

# Services
gem "sendgrid-actionmailer"
gem "aws-sdk-s3", "~> 1"
gem "gravatar_image_tag"

# Security
gem "devise"
gem "omniauth-facebook"
gem "omniauth-google-oauth2"
gem "rolify"
# gem "devise_masquerade"
# gem "devise-two-factor"
# gem "devise_token_auth", ">= 0.1.43.beta1"
gem "pundit"
# gem "recaptcha"

# Debugging & Optimization
gem "active_record_query_trace"
gem "rack-utf8_sanitizer"

# I18n
gem "devise-i18n"
# gem "globalize", github: "globalize/globalize"
gem "rails-i18n"

# Mechanical Line
gem "redis", "~> 4.0"
gem "hiredis"
gem "sidekiq"
gem "sidekiq-cron"
gem "sidekiq-failures"
gem "sitemap_generator"
gem "image_processing", "~> 1.2"

group :development, :test do
  # Call "byebug" anywhere in the code to stop execution and get a debugger console
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "capybara"
  gem "database_cleaner"
  gem "shoulda-matchers"
  gem "rails-controller-testing"
end

group :development, :test, :staging do
  gem "faker", git: "https://github.com/stympy/faker.git", branch: "master"
end

group :development do
  gem "derailed_benchmarks"
  gem "rails-erd", require: false
  gem "i18n-tasks", "~> 0.9.6"
  gem "i18n_generators", "~> 2.1", ">= 2.1.1"
end
