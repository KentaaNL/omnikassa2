class OrderFactory
  def self.create(params = {})
    Omnikassa2::Order.new(
      merchant_order_id: params.fetch(:merchant_order_id, 'order123'),
      amount: params.fetch(:amount, 4999)
    )
  end
end
