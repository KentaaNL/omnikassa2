# frozen_string_literal: true

class MerchantOrderFactory
  def self.create(params = {})
    Omnikassa2::MerchantOrder.new(
      {
        merchant_order_id: 'order123',
        amount: Omnikassa2::Money.new(
          amount: 4999
        ),
        merchant_return_url: 'http://www.example.org/order-completed'
      }.merge(
        params
      )
    )
  end
end
