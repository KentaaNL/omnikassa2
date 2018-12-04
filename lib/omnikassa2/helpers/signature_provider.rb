module Omnikassa2
  class SignatureProvider
    def self.sign(string)
      OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new('sha512'),
        Omnikassa2.signing_key,
        string
      )
    end

    def self.validate(string, signature)
      sign(string) == signature
    end
  end
end
