require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)
require "lasha"

require "dotenv"
Dotenv.load(".env")

# importing through lasha not working
require "devise"
require "slim-rails"
require "sassc-rails"

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.api_only_mode = false
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.action_mailer.default_options = {
      from: "Example Mail <from@email.com>"
    }
  end
end
