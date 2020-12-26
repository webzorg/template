# frozen_string_literal: true

Rails.application.routes.draw do
  rest_actions = %i[index create new edit show update destroy]

  scope "(:locale)", locale: /ka|en/ do
    namespace :admin do
      get  "dashboard/index"
      root "dashboard#index"

      resources :users, only: %i[index show]
    end

    # Phone Number Validation Routes
    # patch "sms/send_verification_code",   defaults: { format: :json }
    # patch "sms/verify_code",              defaults: { format: :json }
    # patch "sms/resend_verification_code", defaults: { format: :json }

    root to: "home#index"
    # get :about,   controller: :home
    # get :contact, controller: :home
    # get :terms,   controller: :home

    namespace :calendar do
      root to: "events#index"
      resources :events
    end

    namespace :wow do
      root to: "characters#index"
      resources :characters
      resources :search, only: :index
      resources :event_signups, only: :create
    end


    # namespace :api do
    #   namespace :v1 do
    #   end
    # end

    mount ActionCable.server => "/cable"
  end
end
