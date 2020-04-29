# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController

  protected

    # The path used after confirmation.
    def after_confirmation_path_for(resource_name, resource)
      bypass_sign_in(resource)
      root_path
    end
end