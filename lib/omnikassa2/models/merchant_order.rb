module Omnikassa2
  class MerchantOrder
    attr_reader :merchant_return_url
    attr_reader :merchant_order_id
    attr_reader :amount

    attr_reader :language
    attr_reader :description

    attr_reader :payment_brand
    attr_reader :payment_brand_force

    def initialize(params)
      @merchant_return_url = params.fetch(:merchant_return_url)
      @merchant_order_id = params.fetch(:merchant_order_id)
      @amount = params.fetch(:amount)

      @language = params.fetch(:language, nil)
      @description = params.fetch(:description, nil)

      @payment_brand = params.fetch(:payment_brand, nil)
      @payment_brand_force = params.fetch(:payment_brand_force, nil)
    end

    def timestamp
      @timestamp ||= Time.now.iso8601(3)
    end
  end
end
