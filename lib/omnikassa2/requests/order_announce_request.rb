# frozen_string_literal: true

require 'omnikassa2/requests/base_request'

module Omnikassa2
  class OrderAnnounceRequest < BaseRequest
    def initialize(merchant_order, config)
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
      '/order/server/api/v2/order'
    end

    def body
      result = {
        'amount' => {
          'amount' => @merchant_order.amount.amount.to_s,
          'currency' => @merchant_order.amount.currency
        },
        'merchantOrderId' => @merchant_order.merchant_order_id,
        'merchantReturnURL' => @merchant_order.merchant_return_url,
        'timestamp' => @merchant_order.timestamp
      }

      result['language'] = @merchant_order.language unless @merchant_order.language.nil?
      result['description'] = @merchant_order.description unless @merchant_order.description.nil?
      result['paymentBrand'] = @merchant_order.payment_brand unless @merchant_order.payment_brand.nil?
      result['paymentBrandForce'] = @merchant_order.payment_brand_force unless @merchant_order.payment_brand_force.nil?

      result
    end

    def response_decorator
      OrderAnnounceResponse
    end
  end
end
