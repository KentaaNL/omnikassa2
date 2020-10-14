# frozen_string_literal: true

require 'time'

module Omnikassa2
  class AccessToken
    EXPIRATION_MARGIN_SECONDS = 300

    attr_reader :token
    attr_reader :valid_until
    attr_reader :duration_in_millis

    def initialize(params)
      @token = params.fetch(:token)
      @valid_until = params.fetch(:valid_until)
      @duration_in_millis = params.fetch(:duration_in_millis)
    end

    def self.from_json(json)
      hash = JSON.parse(json)
      AccessToken.new(
        token: hash['token'],
        valid_until: Time.parse(hash['validUntil']),
        duration_in_millis: hash['durationInMillis']
      )
    end

    def expiring?
      (Time.now + EXPIRATION_MARGIN_SECONDS) - @valid_until > 0
    end

    def to_s
      token
    end
  end
end
