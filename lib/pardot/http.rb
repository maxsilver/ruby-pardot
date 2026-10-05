# frozen_string_literal: true

module Pardot
  module Http
    def get(object, path, params = {}, num_retries = 0)
      smooth_params object, params
      full_path = fullpath object, path
      headers = create_auth_header object
      check_response self.class.get(full_path, query: params, headers: headers)
    rescue Pardot::ExpiredApiKeyError => e
      handle_expired_api_key :get, object, path, params, num_retries, e
    rescue SocketError, Interrupt, EOFError, SystemCallError, Timeout::Error, MultiXml::ParseError => e
      raise Pardot::NetError, e
    end

    def post(object, path, params = {}, num_retries = 0, body_params = {})
      smooth_params object, params
      full_path = fullpath object, path
      headers = create_auth_header object
      check_response self.class.post(full_path, query: params, body: body_params, headers: headers)
    rescue Pardot::ExpiredApiKeyError => e
      handle_expired_api_key :post, object, path, params, num_retries, e, body_params
    rescue SocketError, Interrupt, EOFError, SystemCallError, Timeout::Error, MultiXml::ParseError => e
      raise Pardot::NetError, e
    end

    protected

    # @deprecated With Salesforce OAuth, this method will never be invoked.
    def handle_expired_api_key(method, object, path, params, num_retries, error, body_params = {})
      raise error unless num_retries.zero?

      reauthenticate

      if method == :post
        post object, path, params, 1, body_params
      else
        get object, path, params, 1
      end
    end

    def smooth_params(object, params)
      return if object == "login"

      authenticate unless authenticated?
      params.merge! format: @format
    end

    def create_auth_header(object)
      return if object == "login"

      if using_salesforce_access_token?
        {
          :Authorization => "Bearer #{@salesforce_access_token}",
          "Pardot-Business-Unit-Id" => @business_unit_id
        }
      else
        {Authorization: "Pardot api_key=#{@api_key}, user_key=#{@user_key}"}
      end
    end

    def check_response(http_response)
      rsp = http_response["rsp"] if http_response.respond_to?(:[])
      raise NetError, "Unexpected response format: #{http_response.inspect}" unless rsp.is_a?(Hash)

      error = rsp["err"]
      error ||= "Unknown Failure: #{rsp.inspect}" if rsp["stat"] == "fail"
      content = error["__content__"] if error.is_a?(Hash)

      if using_salesforce_access_token? && [error, content].compact.any? { |value| value.to_s.match?(/access_token is invalid/) }
        raise AccessTokenExpiredError,
          "Access token is invalid. Use Salesforce OAuth to refresh the existing Salesforce access token or to retrieve a new token. See https://developer.salesforce.com/docs/atlas.en-us.mobile_sdk.meta/mobile_sdk/oauth_refresh_token_flow.htm for more information."
      end
      raise ExpiredApiKeyError, @api_key if [error, content].include?("Invalid API key or user key") && @api_key

      raise ResponseError, error if error

      rsp
    end

    def fullpath(object, path)
      full = File.join("/api", object, "version", @version.to_s)
      full = File.join(full, path) unless path.nil?
      full
    end
  end
end
