# frozen_string_literal: true

module Api
  module V1
    module DeviseTokenAuth
      class ConfirmationsController < ::DeviseTokenAuth::ConfirmationsController
        include Lasha::ApiCommon
      end
    end
  end
end
