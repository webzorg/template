# frozen_string_literal: true

class SitemapWorker
  include Sidekiq::Worker
  sidekiq_options queue: :scheduled_jobs

  def perform
    load Rails.root.join("config", "sitemap.rb")
  end
end
