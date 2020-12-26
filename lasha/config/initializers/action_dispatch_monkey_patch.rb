# frozen_string_literal: true

module ActionDispatch
  class Request
    def remote_ip
      @remote_ip ||= (get_header("HTTP_CF_CONNECTING_IP") || get_header("action_dispatch.remote_ip") || ip).to_s
    end
  end
end
