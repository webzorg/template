# frozen_string_literal: true

class Admin::ApplicationController < ApplicationController
  skip_after_action :verify_authorized

  before_action :authenticate_user!
  before_action :verify_admin

  private

    def verify_admin
      return if current_user.admin?

      raise ActionController::RoutingError.new("Not Found")
    end
end
