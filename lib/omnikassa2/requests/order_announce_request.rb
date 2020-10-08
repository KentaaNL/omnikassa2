require 'omnikassa2/requests/base_request'
require 'time'

module Omnikassa2
  class OrderAnnounceRequest < BaseRequest
    def initialize(merchant_order, config = {})
      super(config)
      @merchant_order = merchant_order
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
      result = {
        'amount' => {
          'amount' => @merchant_order.amount.amount.to_s,
          'currency' => @merchant_order.amount.currency
        },
        'merchantOrderId' => @merchant_order.merchant_order_id,
        'merchantReturnURL' => @merchant_order.merchant_return_url,
        'language' => 'EN',
        'timestamp' => @merchant_order.timestamp,
        'signature' => @merchant_order.signature
      }

      result['paymentBrand'] = @merchant_order.payment_brand unless @merchant_order.payment_brand.nil?
      result['paymentBrandForce'] = @merchant_order.payment_brand_force unless @merchant_order.payment_brand_force.nil?

      result
    end

    def response_decorator
      OrderAnnounceResponse
    end
  end
end
