module Omnikassa2
  class MoneyAmount
    attr_reader :amount
    attr_reader :currency

    def initialize(params)
      @amount = params.fetch(:amount)
      @currency = params.dig(:currency, 'EUR')
    end
  end
end
