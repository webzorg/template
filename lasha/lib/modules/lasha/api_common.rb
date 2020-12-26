# frozen_string_literal: true

module Lasha
  module ApiCommon
    extend ActiveSupport::Concern

    included do
      before_action :record_api_user_activity, if: -> { user_signed_in? }

      private

        def record_api_user_activity
          current_user.touch(:last_api_activity_at)
        end
    end
  end
end
