# frozen_string_literal: true

require 'singleton'

module Omnikassa2
  class AccessTokenProvider
    include Singleton

    def access_token
      refresh_token if token_needs_refresh?
      @access_token
    end

    def to_s
      access_token.to_s
    end

    private

    def initialize
      @access_token = nil
    end

    def token_needs_refresh?
      @access_token.nil? || @access_token.expiring?
    end

    def refresh_token
      response = Omnikassa2::RefreshRequest.new.send_request
      raise Omnikassa2::HttpError, response.to_s unless response.success?

      @access_token = response.access_token
    end
  end
end
