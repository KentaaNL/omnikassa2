require 'omnikassa2/requests/base_request'

module Omnikassa2
  class OrderAnnounceRequest < BaseRequest
    def initialize(params)
      super()

      @order = params.fetch(:order)
      @access_token = params.fetch(:access_token)

      #TODO: use order in JSON body
    end

    def http_method
      :post
    end

    def path
      '/order/server/api/order'
    end

    def headers
      {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{ @access_token }"
      }
    end

    def response_decorator
      Omnikassa2::OrderAnnounceResponse
    end
  end
end
