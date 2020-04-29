# frozen_string_literal: true

class Users::ProfilesController < ApplicationController
  skip_after_action :verify_authorized

  before_action :authenticate_user!
  before_action :set_profile

  def show
  end

  def edit
  end

  def update
    if @profile.update_without_password(profile_params)
      bypass_sign_in(@profile) # sign in after successful registration
      redirect_to profile_path, notice: I18n.t(:profile_updated)
    else
      render :edit
    end
  end

  def change_password
  end

  def update_password
    if @profile.update(update_password_params)
      bypass_sign_in(@profile)
      redirect_to profile_path, notice: I18n.t(:password_changed)
    else
      render :change_password
    end
  end

  def clean_notifications
    raise "wrong place" unless current_user
    Notification.where(user_id: current_user.id).delete_all
    redirect_back fallback_location: root_path
  end

  private

    def set_profile
      @profile = current_user
    end

    def update_password_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def profile_params
      params_local = %i[first_name last_name email]
      params_local.push(*:company_name, :phone_number, :address) if current_user.partner?

      params.require(:user).permit(params_local)
    end
end
