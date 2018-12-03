module Omnikassa2
  class SignatureProvider
    def initialize(config)
      @config = config
    end

    def sign(ruby_hash)
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha512'), Omnikassa2.signing_key, signature_fields(ruby_hash))
    end

    private

    def signature_fields(ruby_hash)
      output = ''
      first = true
      @config.each do |config_hash|
        name = config_hash.fetch(:name)
        include_if_empty = config_hash.fetch(:include_if_empty, false)
        value = ruby_hash.fetch(name, nil)

        next if value.nil? && !include_if_empty
        output += !first ? ',' : ''
        output += value.nil? ? '' : value.to_s
        first = false
      end
      output
    end
  end
end
