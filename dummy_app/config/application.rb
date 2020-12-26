# frozen_string_literal: true

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DummyApp
  class Application < Rails::Application
    config.time_zone = "Berlin"

    config.application_name = Rails.application.class.module_parent_name
    config.require_master_key = true
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.generators do |g|
      g.assets                    false
      g.lasha_assets              true
      g.helper                    false
      # g.test_framework            nil
      g.system_tests              nil
      g.jbuilder                  true
      g.lasha_scaffold_controller true
    end

    config.app_name = ENV["RAILS_APP_NAME"]
    config.api_only_mode = ActiveModel::Type::Boolean.new.cast(ENV["API_ONLY_MODE"])

    config.i18n.default_locale = :en
    # config.i18n.available_locales = [:ka, :en]
    # config.i18n.fallbacks = [en: :ka, ka: :en]

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
      %r{https://#{Rails.application.credentials.dig(Rails.env.to_sym, :host)}.*}
    ]

    config.cache_store = :redis_cache_store, {
      expires_in: 1.hour,
      driver: :hiredis,
      url: ENV.fetch("REDISCLOUD_IVORY_URL") { ENV.fetch("REDIS_URL") { "redis://localhost:6379" } }
    }

    config.eager_load_paths << Rails.root.join("lib", "modules")

    config.middleware.insert 0, Rack::UTF8Sanitizer
  end
end
