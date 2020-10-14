# frozen_string_literal: true

require 'openssl'
require 'net/http'
require 'base64'
require 'singleton'

require 'omnikassa2/version'

require 'omnikassa2/helpers/access_token_provider'
require 'omnikassa2/helpers/csv_serializer'
require 'omnikassa2/helpers/signature_service'

require 'omnikassa2/models/access_token'
require 'omnikassa2/models/merchant_order'
require 'omnikassa2/models/money'
require 'omnikassa2/models/notification'
require 'omnikassa2/models/order_result_set'
require 'omnikassa2/models/order_result'

require 'omnikassa2/requests/base_request'
require 'omnikassa2/requests/order_announce_request'
require 'omnikassa2/requests/refresh_request'
require 'omnikassa2/requests/status_pull_request'

require 'omnikassa2/responses/base_response'
require 'omnikassa2/responses/order_announce_response'
require 'omnikassa2/responses/refresh_response'
require 'omnikassa2/responses/status_pull_response'

module Omnikassa2
  class Client
    include Singleton
    attr_reader :refresh_token

    def config(settings)
      @refresh_token = settings.fetch(:refresh_token)
      @signing_key = settings.fetch(:signing_key)
      @base_url = settings.fetch(:base_url, :production)
      @configured = true
    end

    def configured?
      @configured
    end

    def signing_key
      Base64.decode64(@signing_key)
    end

    def base_url
      case @base_url
      when :production
        'https://betalen.rabobank.nl/omnikassa-api'
      when :sandbox
        'https://betalen.rabobank.nl/omnikassa-api-sandbox'
      else
        @base_url
      end
    end

    def announce_order(order_announcement)
      response = Omnikassa2::OrderAnnounceRequest.new(order_announcement).send_request

      raise Omnikassa2::HttpError, response.to_s unless response.success?

      response
    end

    def status_pull(notification)
      more_results_available = true
      while more_results_available
        raise Omnikassa2::InvalidSignatureError unless notification.valid_signature?
        raise Omnikassa2::ExpiringNotificationError if notification.expiring?

        response = Omnikassa2::StatusPullRequest.new(notification).send_request

        raise Omnikassa2::HttpError, response.to_s unless response.success?
        raise Omnikassa2::InvalidSignatureError unless response.valid_signature?

        result_set = response.order_result_set
        result_set.order_results.each do |order_result|
          yield order_result
        end

        more_results_available = result_set.more_order_results_available
      end
    end
  end

  def self.instance
    Omnikassa2::Client.instance
  end

  # The common base class for all exceptions raised by OmniKassa
  class OmniKassaError < StandardError
  end

  class InvalidSignatureError < OmniKassaError
  end

  class ExpiringNotificationError < OmniKassaError
  end

  class HttpError < OmniKassaError
  end
end
