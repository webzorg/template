module Lasha
  module ApiControllerBase
    extend ActiveSupport::Concern

    include ::DeviseTokenAuth::Concerns::SetUserByToken
    include ::Lasha::ApiCommon

    included do
      protect_from_forgery with: :null_session
      respond_to :json
      before_action :authenticate_user!
      skip_before_action :verify_authenticity_token
    end
  end
end
