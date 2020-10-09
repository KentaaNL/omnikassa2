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
      @timestamp
    end

    def to_s
      MerchantOrder.csv_serializer.serialize(self)
    end

    private

    def self.csv_serializer
      Omnikassa2::CSVSerializer.new([
        { field: :timestamp },
        { field: :merchant_order_id },
        {
          field: :amount,
          nested_fields: [
            { field: :currency },
            { field: :amount }
          ]
        },
        { field: :language, include_if_nil: true },
        { field: :description, include_if_nil: true },
        { field: :merchant_return_url },
        { field: :payment_brand },
        { field: :payment_brand_force }
      ])
    end
  end
end
