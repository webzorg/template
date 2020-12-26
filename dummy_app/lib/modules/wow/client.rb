# frozen_string_literal: true

class Wow::Client
  attr_reader :base_api_url, :user
  # attr_accessor :login_retries

  def initialize(user)
    @base_api_url = "https://eu.api.blizzard.com"
    @user = user
    # @creds_path = Rails.root.join("tmp", ".idnak.yml")
    # @login_retries = 0
  end

  def creds
    # { "Authorization" => "Bearer #{user.custom_tokens.fetch('bnet')}" }
    { }
  end

  ENDPOINTS = {
    creature_family_index: "/data/wow/creature-family/index",
    creature_family: ->(id) { "/data/wow/creature-family/#{id}" },

    item_class_index: "/data/wow/item-class/index",
    item_class: ->(id) { "/data/wow/item-class/#{id}" },
    item_subclass: ->(id,id2) { "/data/wow/item-class/#{id}/item-subclass/#{id2}" },
    item: ->(id) { "/data/wow/item/#{id}" },
    item_media: ->(id) { "/data/wow/media/item/#{id}" },

    power_type_index: "/data/wow/power-type/index",
    power_type: ->(id) { "/data/wow/power-type/#{id}" },

    user_info: "/oauth/userinfo",
  }

  def generic_request(
    endpoint: nil,
    endpoint_raw: nil,
    ids: [],
    payload: {},
    headers: {},
    http_method: :get,
    url_params: {},
    block_response: nil
  )
    headers = {
      content_type: "application/json",
    }.merge(creds).merge(headers)

    url_params = { namespace: "static-classic-eu", locale: "en_US" }.merge(url_params)
    url_params = "?#{url_params.to_query}"

    url = if endpoint_raw.present?
            endpoint_raw
          else
            if ids.present?
              "#{base_api_url}#{ENDPOINTS.fetch(endpoint).call(*ids)}#{url_params}"
            else
              "#{base_api_url}#{ENDPOINTS.fetch(endpoint)}#{url_params}"
            end
          end


    resp = RestClient::Request.execute(
      method: http_method,
      url: url,
      use_ssl: true,
      verify_ssl: OpenSSL::SSL::VERIFY_PEER,
      headers: headers,
      payload: payload.to_json,
      block_response: block_response
    )

    Rails.logger.info(resp.try(:body).ai)

    # handle success code returning empty body (for any reason)
    return false if resp.blank? || resp.try(:body).blank?

    resp
  rescue RestClient::ExceptionWithResponse => e
    puts "*** Request Exception ***"
    pp e.http_headers
    puts e.message
    puts e.response
    # puts e.backtrace.first(20)

    # return if login_retries > 2 || ![401].include?(e.http_code)

    # self.login_retries += 1

    # # File.delete(creds_path) if File.exist?(creds_path)

    # # if JSON(e.response).dig("errors").collect { |f| f["cause"] }.include?("INVALID_LOGIN_TOKEN")
    # #   File.delete(creds_path)
    # # end

    # login

    # return generic_request(
    #   endpoint: endpoint,
    #   payload: payload,
    #   headers: headers.merge(get_or_reset_creds),
    #   http_method: http_method
    # )
  end
end