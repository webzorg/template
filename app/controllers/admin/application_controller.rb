# frozen_string_literal: true

module Admin
  class ApplicationController < ApplicationController
    skip_after_action :verify_authorized

    before_action :authenticate_user!
    before_action :verify_admin

    private

      def verify_admin
        return if current_user.admin?

        raise "Not Found"
      end
  end
end
