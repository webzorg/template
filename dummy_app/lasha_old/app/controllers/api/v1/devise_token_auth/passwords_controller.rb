module Api
  module V1
    module DeviseTokenAuth
      class PasswordsController < ::DeviseTokenAuth::PasswordsController
        include Lasha::ApiCommon

        protect_from_forgery with: :null_session
        skip_before_action :verify_authenticity_token
      end
    end
  end
end
