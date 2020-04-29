$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "lasha/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "lasha"
  spec.version     = Lasha::VERSION
  spec.authors     = ["Lasha Abulashvili"]
  spec.email       = ["labulashvili@gmail.com"]
  spec.homepage    = "https://github.com/webzorg/lasha"
  spec.summary     = "
    A collection of best practices that gives this rails engine a potential to be used in almost any rails app.
  "
  spec.description = "
    This rails plugin aims to be a general helper gem for as many rails apps as possible.
    It will to be a collection of features and helpers that most rails apps need.
    Potential of this gem is endless, please fork and add more features!
  "
  spec.license     = "MIT"

  # # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  spec.test_files = Dir["spec/**/*"]

  spec.add_dependency "rails" # , "~> 5.2.3"
  spec.add_dependency "slim-rails"
  spec.add_dependency "sassc-rails"
  spec.add_dependency "pagy"
  spec.add_dependency "ransack"
  spec.add_dependency "aasm"
  spec.add_dependency "active_link_to"
  spec.add_dependency "devise"
  spec.add_dependency "devise_token_auth"
  spec.add_dependency "devise-async"
  spec.add_dependency "rolify"
  spec.add_dependency "devise-i18n"
  spec.add_dependency "rails-i18n"
  spec.add_dependency "omniauth-facebook"
  spec.add_dependency "omniauth-google-oauth2"
  spec.add_dependency "pundit"
  spec.add_dependency "autoprefixer-rails"
  spec.add_dependency "redis", "~> 4.0"
  spec.add_dependency "hiredis"
  spec.add_dependency "sidekiq"
  spec.add_dependency "sidekiq-cron"
  spec.add_dependency "sidekiq-failures"
  spec.add_dependency "sitemap_generator"
  spec.add_dependency "image_processing", "~> 1.2"

  spec.add_development_dependency "pg"
  spec.add_development_dependency "rspec-rails", "~> 3.8"
  spec.add_development_dependency "capybara"
  spec.add_development_dependency "webdrivers"
  spec.add_development_dependency "selenium-webdriver"
  spec.add_development_dependency "factory_bot_rails"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "dotenv"
end
