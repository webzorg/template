module Api
  module V1
    module DeviseTokenAuth
      class TokenValidationsController < ::DeviseTokenAuth::TokenValidationsController
        include Lasha::ApiCommon
      end
    end
  end
end
