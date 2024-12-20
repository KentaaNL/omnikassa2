# frozen_string_literal: true

module Omnikassa2
  class CSVSerializer
    def initialize(config)
      @config = config
    end

    def serialize(object)
      objects = object.is_a?(Array) ? object : [object]
      parts = objects.map do |item|
        extract_fields(item).join(',')
      end
      parts.join(',')
    end

    private

    def extract_fields(object)
      parts = []
      @config.each do |config_hash|
        value = extract_field(object, config_hash)
        parts << value unless value.nil?
      end
      parts
    end

    def extract_field(object, config_hash)
      field = config_hash.fetch(:field)
      include_if_nil = config_hash.fetch(:include_if_nil, false)
      nested_fields = config_hash.fetch(:nested_fields, nil)

      value = extract_value object, field
      value = value.iso8601(3) if value.is_a?(Time)

      if value.nil? || (value.is_a?(Array) && value.empty?)
        include_if_nil ? '' : nil
      elsif nested_fields.nil?
        value
      else
        CSVSerializer.new(nested_fields).serialize(value)
      end
    end

    def extract_value(object, field)
      if object.is_a?(Hash)
        object.fetch(field, nil)
      else
        object.respond_to?(field) ? object.public_send(field) : nil
      end
    end
  end
end
