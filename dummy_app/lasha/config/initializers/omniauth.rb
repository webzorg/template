Devise.setup do |config|
  config.mailer_sender = Rails.application.credentials[:info_mail]
  config.omniauth :facebook,
                  Rails.application.credentials[:facebook].dig(:app_id),
                  Rails.application.credentials[:facebook].dig(:app_secret),
                  callback_url: "http://#{Rails.application.credentials.dig(Rails.env, :host)}/users/auth/facebook/callback"
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           Rails.application.credentials[:google].dig(:app_id),
           Rails.application.credentials[:google].dig(:app_secret)

  provider :bnet,
           Rails.application.credentials[:battle_net].dig(:id),
           Rails.application.credentials[:battle_net].dig(:secret),
           region: "eu"
end
