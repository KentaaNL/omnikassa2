module Omnikassa2
  class MerchantOrder
    attr_reader :merchant_return_url
    attr_reader :merchant_order_id
    attr_reader :amount

    def initialize(params)
      @merchant_return_url = params.fetch(:merchant_return_url)
      @merchant_order_id = params.fetch(:merchant_order_id)
      @amount = params.fetch(:amount)
    end

    def timestamp
      @timestamp ||= Time.now.iso8601(3)
      @timestamp
    end

    def signature
      SignatureProvider.sign to_s
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
        { field: :merchant_return_url }
      ])
    end
  end
end
