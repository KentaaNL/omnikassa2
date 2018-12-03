module Omnikassa2
  class SignatureProvider
    def initialize(config)
      @config = config
    end

    def sign(object)
      OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new('sha512'),
        Omnikassa2.signing_key,
        comma_separated_fields(object)
      )
    end

    def validate(object, signature)
      sign(object) == signature
    end

    private

    def comma_separated_fields(object)
      fields(object).join(',')
    end

    def fields(object)
      parts = []
      @config.each do |config_hash|
        value = field object, config_hash
        parts << value unless value.nil?
      end
      parts
    end

    def field(object, config_hash)
      path = config_hash.fetch(:path)
      include_if_empty = config_hash.fetch(:include_if_empty, false)

      value = extract_value object, path

      if value.nil?
        include_if_empty ? '' : nil
      else
        value
      end
    end

    def extract_value(object, path)
      path_parts = path.kind_of?(Array) ? path : [path]
      current_node = object
      path_parts.each do |key|
        if current_node.nil?
          next
        elsif(current_node.kind_of?(Hash))
          current_node = current_node.fetch(key, nil)
        else
          current_node = current_node.respond_to?(key) ? current_node.public_send(key) : nil
        end
      end
      current_node
    end
  end
end
