require 'time'

module Omnikassa2
  class Announce
    attr_accessor :params

    def initialize(params)
      self.params = params
    end

    def self.uri
      tmp_url = Omnikassa2.url + '/order/server/api/order'
      URI(tmp_url)
    end

    def timestamp
      Time.now.iso8601(3)
    end

    def request_data
      {
        "timestamp" => timestamp,
        "merchantOrderId" => params[:merchant_order_id],
        "amount" =>
          {
            "amount" =>  params[:amount].to_i.to_s,
            "currency" => 'EUR',
          },
        "merchantReturnURL" => 'http://www.google.com', #TODO
        "paymentBrand" => params[:payment_brand],
        "paymentBrandForce" => "FORCE_ALWAYS"
      }
    end

    def request_signature
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha512'), Omnikassa2.signing_key, request_data_string)
    end

    def request_body
      request_data.merge('signature' => request_signature)
    end

    def request_keys
      [
        'timestamp',
        'merchantOrderId',
        'amount currency',
        'amount amount',
        'language',
        'description',
        'merchantReturnURL',
        'paymentBrand',
        'paymentBrandForce'
      ]
    end

    def request_data_string
      sign_data(request_keys, request_data).join(',')
    end

    def redirect_url
      @redirect_url ||= response_data['redirectUrl'] if response_data.present? && verify_response_signature
    end

    def response_data
      @response_data ||= connect
    end

    def connect
      req = Net::HTTP::Post.new(Omnikassa2::Announce.uri, 'Content-Type' => 'application/json')
      req['Authorization'] = "Bearer #{Omnikassa2.access_token}"
      req.body = request_body.to_json
      res = Net::HTTP.start(Omnikassa2::Announce.uri.hostname, Omnikassa2::Announce.uri.port, use_ssl: true) { |http| http.request(req) }
      JSON.parse(res.body)
    end

    def verify_response_signature
      response_data.nil? || response_data['signature'] == response_data_signature
    end

    def response_data_signature
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha512'), Omnikassa2.signing_key, response_data_string)
    end

    def response_data_string
      sign_data(response_keys, response_data).join(',')
    end

    def sign_data sign_keys, values
      sign_keys.map do |key|
        key.split(' ').inject(values) { |memo, value| memo.fetch(value, '') }.to_s
      end
    end

    def response_keys
      [
        'redirectUrl'
      ]
    end
  end
end
