require 'omnikassa2/requests/base_request'

module Omnikassa2
  class RefreshRequest < BaseRequest
    def http_method
      :get
    end

    def authorization_method
      :refresh_token
    end

    def path
      '/gatekeeper/refresh'
    end

    def response_decorator
      RefreshResponse
    end
  end
end
