# frozen_string_literal: true

module Omnikassa2
  class BaseRequest
    def initialize(config)
      @config = config
      access_token = @config.fetch(:access_token, Omnikassa2::AccessTokenProvider.new(@config))
      @config.merge!(access_token: access_token)
    end

    def http_method
      :get
    end

    def authorization_method
      nil
    end

    def custom_token
      nil
    end

    def content_type
      nil
    end

    def path
      '/'
    end

    def body
      nil
    end

    def response_decorator
      Omnikassa2::BaseResponse
    end

    def send_request
      request = request_class.new(uri, headers)
      request.body = body_raw

      http_response = Net::HTTP.start(
        uri.hostname,
        uri.port,
        use_ssl: true
      ) do |http|
        http.request(request)
      end

      response_decorator.nil? ? http_response : response_decorator.new(http_response, @config)
    end

    def headers
      value = {}
      add_authorization_header value
      add_content_type_header value
      value
    end

    private

    def base_url
      case @config[:base_url]
      when :production
        'https://betalen.rabobank.nl/omnikassa-api'
      when :sandbox
        'https://betalen.rabobank.nl/omnikassa-api-sandbox'
      else
        @config[:base_url]
      end
    end

    def body_raw
      return nil if body.nil?

      case content_type
      when :json
        body.to_json
      else
        body
      end
    end

    def request_class
      case http_method
      when :get
        Net::HTTP::Get
      when :post
        Net::HTTP::Post
      when :put
        Net::HTTP::Put
      when :delete
        Net::HTTP::Delete
      end
    end

    def uri
      tmp_url = base_url + path
      URI(tmp_url)
    end

    def add_authorization_header(value)
      case authorization_method
      when :refresh_token
        value['Authorization'] = "Bearer #{@config[:refresh_token]}"
      when :access_token
        value['Authorization'] = "Bearer #{@config[:access_token]}"
      when :custom_token
        value['Authorization'] = "Bearer #{custom_token}"
      end
    end

    def add_content_type_header(value)
      case content_type
      when :json
        value['Content-Type'] = 'application/json'
      end
    end
  end
end
