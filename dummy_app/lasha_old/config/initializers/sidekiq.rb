require "sidekiq/web"
require "sidekiq/cron/web"

Sidekiq.default_worker_options = {
  backtrace: true,
  retry: false
}

Sidekiq.configure_server do |config|
  config.failures_max_count = 5000 # false
  config.failures_default_mode = :all # :all, :exhausted or :off
  config.redis = {
    url: ENV.fetch("REDISCLOUD_IVORY_URL") { ENV.fetch("REDIS_URL") { "redis://localhost:6379" } },
    network_timeout: 5
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV.fetch("REDISCLOUD_IVORY_URL") { ENV.fetch("REDIS_URL") { "redis://localhost:6379" } },
    network_timeout: 5
  }
end

schedule_file = "config/schedule.yml"
Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file) if File.exist?(schedule_file) && Sidekiq.server?
