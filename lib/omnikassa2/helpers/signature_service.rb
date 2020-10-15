# frozen_string_literal: true

module Omnikassa2
  class SignatureService
    def self.sign(string, signing_key)
      OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new('sha512'),
        signing_key,
        string
      )
    end

    def self.validate(string, signature, signing_key)
      sign(string, signing_key) == signature
    end
  end
end
