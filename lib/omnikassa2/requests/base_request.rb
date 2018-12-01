module Omnikassa2
  class BaseRequest
    def initialize(params = {})
      @access_token = params.fetch(:access_token, nil)
    end

    def http_method
      :get
    end

    def authorization_method
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
      Omnikassa2::BaserResponse
    end

    def send
      request = request_class.new(uri, headers)
      request.body = body

      http_response = Net::HTTP.start(
        uri.hostname,
        uri.port,
        use_ssl: true
      ) do |http|
        http.request(request)
      end

      response_decorator.nil? ? http_response : response_decorator.new(http_response)
    end

    def headers
      value = {}
      add_authorization_header value
      add_content_type_header value
      value
    end

    private

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
      tmp_url = Omnikassa2.base_url + path
      URI(tmp_url)
    end

    def add_authorization_header(value)
      case authorization_method
      when :refresh_token
        value['Authorization'] = "Bearer #{Omnikassa2.refresh_token}"
      when :access_token
        value['Authorization'] = "Bearer #{@access_token}"
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
