# frozen_string_literal: true

module Omnikassa2
  module SignatureService
    module_function

    def sign(string, base64_signing_key)
      OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new('sha512'),
        Base64.decode64(base64_signing_key),
        string
      )
    end

    def validate(string, signature, base64_signing_key)
      sign(string, base64_signing_key) == signature
    end
  end
end
