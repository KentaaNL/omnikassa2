module Omnikassa2
  class Order
    attr_reader :merchant_order_id
    attr_reader :amount

    def initialize(params)
      @merchant_order_id = params.fetch(:merchant_order_id)
      @amount = params.fetch(:amount)
    end
  end
end
