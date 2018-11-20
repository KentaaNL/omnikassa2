module Omnikassa2
  class Status
    attr_accessor :notification_token, :data

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
      self.data = JSON.parse(@res.body)
      data if verify_signature
    end

    def verify_signature
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha512'), Omnikassa2.signing_key, data_string) == data['signature']
    end

    def data_string
      keys.map do |key|
        path = key.split(' ')
        path.inject(data) { |memo, value| memo.fetch(value, '').to_s }
      end.join(",") + data['orderResults'].map do |order_data|
        order_keys do |key|
          path = key.split(' ')
          path.inject(order_data) { |memo, value| memo.fetch(value, '').to_s }
        end.join(",")
      end
    end

    def keys
      [
        'moreOrderResultsAvailable'
      ]
    end

    def order_keys
      [
        'merchantOrderId',
        'omnikassaOrderId',
        'poiId',
        'orderStatus',
        'orderStatusDateTime',
        'errorCode',
        'paidAmount currency',
        'paidAmount amount',
        'totalAmount currency',
        'totalAmount amount '
      ]
    end

    def results
      get_results.map { |res| [res['merchantOrderId'], res['orderStatus']] }.to_h
    end

    def get_results
      i = 0
      return @order_results unless @order_results.nil?
      @order_results = []
      moreOrderResultsAvailable = true
      while moreOrderResultsAvailable && i < 100
        i += 1
        data = connect
        @order_results = @order_results + data['orderResults']
        moreOrderResultsAvailable = data['moreOrderResultsAvailable']
      end
      return @order_results
    end
  end
end
