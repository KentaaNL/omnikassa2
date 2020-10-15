# frozen_string_literal: true

module Omnikassa2
  class Client
    attr_reader :refresh_token

    def initialize(refresh_token:, signing_key:, base_url: :production)
      @refresh_token = refresh_token
      @signing_key = signing_key
      @base_url = base_url
    end

    def config
      {
        base_url: base_url,
        signing_key: signing_key,
        refresh_token: refresh_token
      }
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
      response = Omnikassa2::OrderAnnounceRequest.new(order_announcement, config).send_request

      raise Omnikassa2::HttpError, response.to_s unless response.success?

      response
    end

    def status_pull(notification)
      more_results_available = true
      while more_results_available
        raise Omnikassa2::InvalidSignatureError unless notification.valid_signature?(signing_key)
        raise Omnikassa2::ExpiringNotificationError if notification.expiring?

        response = Omnikassa2::StatusPullRequest.new(notification, config).send_request

        raise Omnikassa2::HttpError, response.to_s unless response.success?
        raise Omnikassa2::InvalidSignatureError unless response.valid_signature?(signing_key)

        result_set = response.order_result_set
        result_set.order_results.each do |order_result|
          yield order_result
        end

        more_results_available = result_set.more_order_results_available
      end
    end
  end
end
