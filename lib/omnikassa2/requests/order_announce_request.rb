require 'omnikassa2/requests/base_request'
require 'time'

module Omnikassa2
  class OrderAnnounceRequest < BaseRequest
    def initialize(params)
      super(params)

      @order = params.fetch(:order)
    end

    def http_method
      :post
    end

    def content_type
      :json
    end

    def authorization_method
      :access_token
    end

    def path
      '/order/server/api/order'
    end

    def body
      {
        'timestamp': Time.now.iso8601(3)
      }
    end

    def response_decorator
      Omnikassa2::OrderAnnounceResponse
    end
  end
end
