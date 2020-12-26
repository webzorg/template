# frozen_string_literal: true

require "net/http"

module SmsHelper
  API_URI = URI.parse("https://smsoffice.ge/api/v2/send/")

  def generate_pass_code
    rand(0_000..9_999).to_s.rjust(4, "0")
  end

  def generate_long_pass_code
    rand(000_000..999_999).to_s.rjust(6, "0")
  end

  class << self
    # params -> { destination: "", content: "" }
    def sms(destination, content)
      http = Net::HTTP.new(API_URI.host, API_URI.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(API_URI.request_uri)
      request.set_form_data(
        key: Rails.application.credentials[:sms_office_key],
        destination: destination,
        sender: "wishmaster",
        content: content,
        urgent: true
      )

      if Rails.env.production? || Rails.env.staging?
        response = http.request(request)
        ActiveSupport::JSON.decode(response.body)
      else
        { Success: true }.with_indifferent_access
      end

      # sample response
      # { "Success"=>true, "Message"=>"accepted", "Output"=>nil, "ErrorCode"=>0 }
    end

    private

      def content(params)
        if params[:template]
          ActionController::Base.render(
            params[:template],
            locals: {
              user: params[:user],
              code: params[:content]
            }
          )
        else
          params[:content]
        end
      end
  end
end
