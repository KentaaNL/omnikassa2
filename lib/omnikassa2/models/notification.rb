# frozen_string_literal: true

require 'time'

module Omnikassa2
  class Notification
    EXPIRATION_MARGIN_SECONDS = 30

    attr_reader :authentication
    attr_reader :expiry
    attr_reader :event_name
    attr_reader :poi_id
    attr_reader :signature

    def initialize(params)
      @authentication = params.fetch(:authentication)
      @expiry = params.fetch(:expiry)
      @event_name = params.fetch(:event_name)
      @poi_id = params.fetch(:poi_id)
      @signature = params.fetch(:signature)
    end

    def self.from_json(json)
      hash = JSON.parse(json, symbolize_names: true)
      params = {
        authentication: hash[:authentication],
        expiry: Time.parse(hash[:expiry]),
        event_name: hash[:eventName],
        poi_id: hash[:poiId],
        signature: hash[:signature]
      }

      Notification.new(params)
    end

    def expiring?
      (Time.now + EXPIRATION_MARGIN_SECONDS) - @expiry > 0
    end

    def valid_signature?(signing_key)
      SignatureService.validate(to_s, @signature, signing_key)
    end

    def to_s
      Notification.csv_serializer.serialize(self)
    end

    def self.csv_serializer
      CSVSerializer.new([
        { field: :authentication },
        { field: :expiry },
        { field: :event_name },
        { field: :poi_id }
      ])
    end
  end
end
