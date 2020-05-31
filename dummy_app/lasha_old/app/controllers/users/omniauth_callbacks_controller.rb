class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to registration_url
    end
  end

  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to registration_url
    end
  end

  def bnet
    @user = User.from_omniauth(request.env["omniauth.auth"])
    @user.update(custom_tokens:
      @user.custom_tokens.merge(bnet: request.env["omniauth.auth"]["credentials"]["token"])
    )

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Battle.net") if is_navigational_format?
    else
      session["devise.bnet_data"] = request.env["omniauth.auth"]
      redirect_to registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end
