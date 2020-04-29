Rails.application.routes.draw do
  def db_ready?
    database_exists? && ActiveRecord::Base.connection.table_exists?("users")
  end

  def database_exists?
    ActiveRecord::Base.connection
  rescue ActiveRecord::NoDatabaseError
    false
  else
    true
  end

  sidekiq_web_constraint = lambda do |request|
    current_user = request.env["warden"].user
    current_user.present? && current_user.admin?
  end

  constraints sidekiq_web_constraint do
    mount Sidekiq::Web => "/admin/sidekiq"
  end

  # omniauth_callbacks does't support scoping
  devise_for :users, only: :omniauth_callbacks, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
  } if db_ready?

  scope "(:locale)", locale: /ka|en/ do
    devise_for :users, skip: %i[omniauth_callbacks sessions registrations passwords confirmations], controllers: {
      # confirmations: "users/confirmations",
      # passwords:     "users/passwords",
      # registrations: "users/registrations",
      # sessions:      "users/sessions"
    } if db_ready?
    as :user do
      scope nil, module: :users do
        # Confirmations
        get  "users/confirmation/new", to: "confirmations#new",  as: :new_user_confirmation
        get  "users/confirmation",     to: "confirmations#show", as: :user_confirmation
        post "users/confirmation",     to: "confirmations#create"

        # # Passwords
        get   "users/password/new",  to: "passwords#new",      as: :new_user_password
        get   "users/password/edit", to: "passwords#edit",     as: :edit_user_password
        # patch "users/password",      to: "passwords#update",   as: :user_password
        put   "users/password",      to: "passwords#update", as: :user_password
        post  "users/password",      to: "passwords#create"

        # # Registrations
        # get    "users/cancel",         to: "registrations#cancel",      as: :cancel_user_registration
        get    "user_registration",    to: "registrations#new",         as: :new_user_registration
        get    "partner_registration", to: "registrations#new_partner", as: :new_partner_registration
        # get    "users/edit",           to: "registrations#edit",        as: :edit_user_registration
        # patch  "users",                to: "registrations#update",      as: :user_registration
        # put    "users",                to: "registrations#update"
        # delete "users",                to: "registrations#destroy"
        post   "registration",           to: "registrations#create"

        # Sessions
        get    "login",  to: "sessions#new",     as: :new_user_session
        post   "login",  to: "sessions#create",  as: :user_session
        delete "logout", to: "sessions#destroy", as: :destroy_user_session

        # Profile
        resource :profile, only: %i[show edit update]
        get    "profile/change_password",     to: "profiles#change_password"
        patch  "profile/change_password",     to: "profiles#update_password"
        delete "profile/clean_notifications", to: "profiles#clean_notifications"
      end
    end
  end

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for "User", at: "auth", skip: %i[omniauth_callbacks unlocks], controllers: {
        confirmations:      "api/v1/devise_token_auth/confirmations",
        passwords:          "api/v1/devise_token_auth/passwords",
        # omniauth_callbacks: "devise_token_auth/omniauth_callbacks",
        registrations:      "api/v1/devise_token_auth/registrations",
        sessions:           "api/v1/devise_token_auth/sessions",
        token_validations:  "api/v1/devise_token_auth/token_validations"
      } if db_ready?
    end
  end
end
