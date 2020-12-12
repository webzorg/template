class ApplicationController < ActionController::Base
  include Lasha::ControllerBase

  before_action :api_only_mode, if: -> { Rails.configuration.api_only_mode }

  private

    def api_only_mode
      not_found unless request.format == :json
    end
end
