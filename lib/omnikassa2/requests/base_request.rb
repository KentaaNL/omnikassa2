module Omnikassa2
  class BaseRequest
    def http_method
      :get
    end

    def path
      '/'
    end

    def headers
      {}
    end

    def response_decorator
      Omnikassa2::BaserResponse
    end

    def send
      request = request_class.new(uri)

      headers.each do |name, value|
        request[name] = value
      end

      http_response = Net::HTTP.start(
        uri.hostname,
        uri.port,
        use_ssl: true
      ) do |http|
        http.request(request)
      end

      response_decorator.nil? ? http_response : response_decorator.new(http_response)
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
  end
end
