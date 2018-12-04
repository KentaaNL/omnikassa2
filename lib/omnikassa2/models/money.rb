module Omnikassa2
  class Money
    attr_reader :amount
    attr_reader :currency

    def initialize(params)
      @amount = params.fetch(:amount)
      @currency = params.fetch(:currency, 'EUR')
    end
  end
end
