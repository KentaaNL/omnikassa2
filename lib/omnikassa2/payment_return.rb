module Omnikassa2
  class PaymentReturn
    attr_accessor :data

    def initialize(data)
      self.data = data
    end

    def verified_data
      data if verify_signature
    end

    def verify_signature
      data.nil? || data['signature'] == data_signature
    end

    def data_signature
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha512'), Omnikassa2.signing_key, data_string)
    end

    def data_string
      sign_data(keys, data).join(',')
    end

    def sign_data sign_keys, values
      sign_keys.map do |key|
        key.split(' ').inject(values) { |memo, value| memo.fetch(value, '') }.to_s
      end
    end

    def keys
      [
        'order_id',
        'status'
      ]
    end
  end
end
