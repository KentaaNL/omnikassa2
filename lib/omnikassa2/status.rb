module Omnikassa2
  class Status
    attr_accessor :notification_token

    def initialize(notification_token)
      self.notification_token = notification_token
    end

    def self.uri
      tmp_url = Omnikassa2.url + '/order/server/api/events/results/merchant.order.status.changed'
      URI(tmp_url)
    end

    def connect
      req = Net::HTTP::Get.new(Omnikassa2::Status.uri)
      req['Authorization'] = "Bearer #{notification_token}"
      @res = Net::HTTP.start(Omnikassa2::Status.uri.hostname, Omnikassa2::Status.uri.port, use_ssl: true) { |http| http.request(req) }
      JSON.parse(@res.body)
    end

    def results
      get_results.map { |res| [res['merchantOrderId'], res['orderStatus']] }.to_h
    end

    def get_results
      return @order_results unless @order_results.nil?
      @order_results = []
      moreOrderResultsAvailable = true
      while moreOrderResultsAvailable
        data = connect
        @order_results = @order_results + data['orderResults']
        moreOrderResultsAvailable = data['moreOrderResultsAvailable']
      end
      return @order_results
    end
  end
end
