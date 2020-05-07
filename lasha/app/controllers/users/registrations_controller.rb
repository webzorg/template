# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  skip_after_action :verify_authorized

  prepend_before_action :redirect_if_authorized, only: %i[new create] # new_partner

  def new
    preset_new_params_for
  end

  # def new_partner
  #   preset_new_params_for(:partner)
  # end

  def create
    @user = User.new(registration_params)
    role_sym = params[:user][:role].to_sym

    role_valid = @user.validate_and_initialize_role(role_sym)

    if @user.save && role_valid
      # bypass_sign_in(@user) # not compatible with confirmable
      redirect_to new_user_session_path, notice: I18n.t("devise.confirmations.send_instructions")
    # elsif role_sym.eql?(:client) || !role_valid
    #   preset_new_params_for(:client)
    #   render :new
    # elsif role_sym.eql?(:partner) || !role_valid
    #   preset_new_params_for(:partner)
    #   render :new_partner
    else
      preset_new_params_for
      render :new
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  private

    def preset_new_params_for(role=nil)
      @user ||= User.new
      # @role = role
    end

    def registration_params
      params_local = %i[
        first_name
        last_name
        email
        password
        password_confirmation
      ]

      # if params[:user][:role] == "partner"
      #   params_local += %i[company_name phone_number address]
      # end
      params.require(:user).permit(params_local)
    end

    def redirect_if_authorized
      redirect_to after_sign_in_path_for(current_user) if current_user.present?
    end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
