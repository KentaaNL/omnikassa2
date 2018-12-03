module Omnikassa2
  class OrderAnnouncement
    attr_reader :merchant_return_url
    attr_reader :merchant_order_id
    attr_reader :amount

    def initialize(params)
      @merchant_return_url = params.fetch(:merchant_return_url)
      @merchant_order_id = params.fetch(:merchant_order_id)
      @amount = params.fetch(:amount)
    end
  end
end
