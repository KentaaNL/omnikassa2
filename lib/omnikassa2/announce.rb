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

    def data
      {
        "timestamp" => timestamp,
        "merchantOrderId" => params[:merchant_order_id],
        "amount" =>
          {
            "amount" =>  params[:amount].to_i.to_s,
            "currency" => Omnikassa2.currency,
          },
        "merchantReturnURL" => Omnikassa2.merchant_return_url,
        "paymentBrand" => params[:payment_brand],
        "paymentBrandForce" => "FORCE_ALWAYS"
      }
    end

    def signature
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha512'), Omnikassa2.signing_key, data_string)
    end

    def body
      data.merge('signature' => signature)
    end

    def keys
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

    def data_string
      keys.map do |key|
        path = key.split(' ')
        path.inject(data) { |memo, value| memo.fetch(value, '') }
      end.join(",")
    end

    def redirect_url
      JSON.parse(connect).fetch('redirectUrl')
    end

    def connect
      req = Net::HTTP::Post.new(Omnikassa2::Announce.uri, 'Content-Type' => 'application/json')
      req['Authorization'] = "Bearer #{Omnikassa2.access_token}"
      req.body = body.to_json
      res = Net::HTTP.start(Omnikassa2::Announce.uri.hostname, Omnikassa2::Announce.uri.port, use_ssl: true) { |http| http.request(req) }
      return res.body
    end

  end
end
