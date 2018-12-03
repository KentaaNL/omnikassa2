require 'omnikassa2/requests/base_request'
require 'time'

module Omnikassa2
  class OrderAnnounceRequest < BaseRequest
    def initialize(order_announcement, config)
      super(config)

      @order_announcement = order_announcement
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
      body = unsigned_body
      body['signature'] = OrderAnnounceRequest.signature_provider.sign unsigned_body
      body
    end

    def response_decorator
      Omnikassa2::OrderAnnounceResponse
    end

    private

    def unsigned_body
      {
        timestamp: Time.now.iso8601(3),
        merchantOrderId: @order_announcement.merchant_order_id,
        amount: {
          amount: @order_announcement.amount.amount.to_s,
          currency: @order_announcement.amount.currency
        },
        merchantReturnURL: @order_announcement.merchant_return_url,
      }
    end

    def self.signature_provider
      Omnikassa2::SignatureProvider.new([
        { name: :timestamp },
        { name: :merchantOrderId },
        { name: [:amount, :currency] },
        { name: [:amount, :amount ] },
        { name: :language, include_if_empty: true },
        { name: :description, include_if_empty: true },
        { name: :merchantReturnURL }
      ])
    end
  end
end
