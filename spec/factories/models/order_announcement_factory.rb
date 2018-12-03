class OrderAnnouncementFactory
  def self.create(params = {})
    Omnikassa2::OrderAnnouncement.new(
      merchant_order_id: params.fetch(:merchant_order_id, 'order123'),
      amount: params.fetch(:amount, Omnikassa2::MoneyAmount.new(
        amount: 4999
      )),
      merchant_return_url: 'http://www.example.org/order-completed'
    )
  end
end
