module Lasha
  class Engine < ::Rails::Engine
    config.eager_load_paths << File.expand_path("../modules", __dir__)
    config.app_generators do |g|
      g.assets            false
      g.helper            false
      g.test_framework    :rspec
      g.system_tests      nil # Don't generate system test files.
      g.jbuilder          false
      g.fixture_replacement :factory_bot
      g.factory_bot dir: "spec/factories"
    end
  end
end
