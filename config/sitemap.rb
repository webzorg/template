# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://#{Rails.application.credentials.production[:host]}"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'

  # add about_path,                 priority: 1.0, changefreq: "weekly"
  # add contact_path,               priority: 0.9, changefreq: "weekly"
  # add terms_path,                 priority: 0.9, changefreq: "weekly"
  add new_user_registration_path, priority: 0.6, changefreq: "weekly"
  add new_user_session_path,      priority: 0.5, changefreq: "weekly"

  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
end

SitemapGenerator::Sitemap.ping_search_engines