# frozen_string_literal: true

module Omnikassa2
  class SignatureService
    def self.sign(string)
      OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new('sha512'),
        Omnikassa2.instance.signing_key,
        string
      )
    end

    def self.validate(string, signature)
      sign(string) == signature
    end
  end
end
