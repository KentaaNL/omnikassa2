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

    def timestamp
      @timestamp ||= Time.now.iso8601(3)
      @timestamp
    end

    def signature
      OrderAnnouncement.signature_provider.sign self
    end

    private

    def self.signature_provider
      Omnikassa2::SignatureProvider.new([
        { path: :timestamp },
        { path: :merchant_order_id },
        { path: [:amount, :currency] },
        { path: [:amount, :amount ] },
        { path: :language, include_if_empty: true },
        { path: :description, include_if_empty: true },
        { path: :merchant_return_url }
      ])
    end
  end
end
