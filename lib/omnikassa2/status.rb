module Omnikassa2
  class Status
    attr_accessor :notification_token, :data

    def initialize(notification_token)
      self.notification_token = notification_token
      self.data  = {"signature"=>"ee778bec954c7765f4ae62f11c217bbb4bf44901741d3c66b36cb298b2147708e6ebc921db131bacd264f66d5dec8d9e572ede5bc4953e49b940aeb74c155ea5", "moreOrderResultsAvailable"=>false, "orderResults"=>[{"merchantOrderId"=>"xvBypP9WJE", "omnikassaOrderId"=>"4b598237-360b-4000-8009-89a62b8c6d2c", "poiId"=>"10181", "orderStatus"=>"COMPLETED", "orderStatusDateTime"=>"2018-11-20T13:54:31.552+01:00", "errorCode"=>"", "paidAmount"=>{"currency"=>"EUR", "amount"=>"2000"}, "totalAmount"=>{"currency"=>"EUR", "amount"=>"2000"}}]}
      verify_signature
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
        path.inject(data) { |memo, value| memo.fetch(value, '') }.to_s
      end.join(",") + data['orderResults'].map do |order_data|
        order_keys.map do |key|
          path = key.split(' ')
          path.inject(order_data) { |memo, value| memo.fetch(value, '') }.to_s
        end.join(",")
      end.join(",")
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
        'totalAmount amount'
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
