Devise.setup do |config|
  config.mailer_sender = Rails.application.credentials.dig(:info_mail)
  config.omniauth :facebook,
                  Rails.application.credentials.dig(:facebook, :app_id),
                  Rails.application.credentials.dig(:facebook, :app_secret),
                  callback_url: "http://#{Rails.application.credentials.dig(Rails.env, :host)}/users/auth/facebook/callback"
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           Rails.application.credentials.dig(:google, :app_id),
           Rails.application.credentials.dig(:google, :app_secret)
end
