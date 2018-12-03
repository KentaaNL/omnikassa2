module Omnikassa2
  class SignatureProvider
    def initialize(config)
      @config = config
    end

    def sign(ruby_hash)
      OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new('sha512'),
        Omnikassa2.signing_key,
        comma_separated_fields(ruby_hash)
      )
    end

    private
    def comma_separated_fields(ruby_hash)
      fields(ruby_hash).join(',')
    end

    def fields(ruby_hash)
      parts = []
      @config.each do |config_hash|
        value = field ruby_hash, config_hash
        parts << value unless value.nil?
      end
      parts
    end

    def field(ruby_hash, config_hash)
      path = config_hash.fetch(:path)
      include_if_empty = config_hash.fetch(:include_if_empty, false)

      value = extract_value ruby_hash, path

      if value.nil?
        include_if_empty ? '' : nil
      else
        value
      end
    end

    def extract_value(ruby_hash, path)
      path_parts = path.kind_of?(Array) ? path : [path]
      current_node = ruby_hash
      path_parts.each do |key|
        next if current_node.nil?
        current_node = current_node.fetch(key, nil)
      end
      current_node
    end
  end
end
