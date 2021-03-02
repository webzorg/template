module Api
  module V1
    class ApplicationController < ActionController::Base
      include ::DeviseTokenAuth::Concerns::SetUserByToken

      protect_from_forgery with: :null_session
      respond_to :json

      before_action :authenticate_user!
      before_action :set_locale
      before_action :record_api_user_activity, if: -> { user_signed_in? }
      skip_before_action :verify_authenticity_token

      private

        def set_locale
          I18n.locale = params[:lang] if params[:lang].present? && I18n.available_locales.include?(params[:lang].to_sym)
        end

        def record_api_user_activity
          current_user.touch(:last_api_activity_at)
        end
    end
  end
end
