module Omnikassa2
  class Status
    attr_reader :notification_token, :data

    def initialize(notification_token)
      @notification_token = notification_token
      @data_pages = []
    end

    def self.uri
      tmp_url = Omnikassa2.url + '/order/server/api/events/results/merchant.order.status.changed'
      URI(tmp_url)
    end

    def order_results
      @order_results ||= data_pages.map { |data_page| data_page.fetch('orderResults', []) }.sum
    end

    def data_pages
      @data_pages << read_page while more_order_results_available? && verify_signature && @data_pages.size < 100
      return @data_pages
    end

    def read_page
      req = Net::HTTP::Get.new(Omnikassa2::Status.uri)
      req['Authorization'] = "Bearer #{notification_token}"
      res = Net::HTTP.start(Omnikassa2::Status.uri.hostname, Omnikassa2::Status.uri.port, use_ssl: true) { |http| http.request(req) }
      @data = JSON.parse(res.body)
    end

    def more_order_results_available?
      data.nil? || data['moreOrderResultsAvailable']
    end

    def verify_signature
      data.nil? || data['signature'] == data_signature
    end

    def data_signature
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha512'), Omnikassa2.signing_key, data_string)
    end

    def data_string
      (sign_data(keys, data) + data['orderResults'].map { |order_data| sign_data(order_keys, order_data) }.flatten).join(',')
    end

    def sign_data sign_keys, values
      sign_keys.map do |key|
        key.split(' ').inject(values) { |memo, value| memo.fetch(value, '') }.to_s
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
        'totalAmount amount'
      ]
    end
  end
end
