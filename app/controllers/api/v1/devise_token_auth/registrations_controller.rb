# frozen_string_literal: true

module Api
  module V1
    module DeviseTokenAuth
      class RegistrationsController #< ::DeviseTokenAuth::RegistrationsController
        # include ApiCommon

        # protect_from_forgery with: :null_session
        # skip_before_action :verify_authenticity_token
        # before_action :configure_sign_up_params,      only: :create
        # before_action :configure_change_email_params, only: :update

        def new
          @attributes = %i[
            email
            password
            password_confirmation
            agreement
            referrer_id
            country
          ]
          @countries = ISO3166::Country.all.sort_by(&:name)
        end

        def destroy
          render json: { errors: ["never happened ;)"] }
        end

        # def render_create_success
        #   render json: current_user.to_json(only: [:email, :uid, :country])
        # end

        # def render_update_success
        #   render json: current_user.to_json(only: [:email, :uid, :country])
        # end

        protected

          def configure_sign_up_params
            devise_parameter_sanitizer.permit(
              :sign_up,
              keys: %i[
                email
                password
                password_confirmation
                agreement
                referrer_id
                country
              ]
            )
          end

          def configure_change_email_params
            devise_parameter_sanitizer.permit(
              :sign_up,
              keys: %i[
                email
                password
                password_confirmation
              ]
            )
          end
      end
    end
  end
end
