# frozen_string_literal: true

module Omnikassa2
  class Client
    attr_reader :refresh_token, :signing_key, :base_url

    def initialize(refresh_token:, signing_key:, base_url: :production)
      @refresh_token = refresh_token
      @signing_key = signing_key
      @base_url = base_url
    end

    def announce_order(order_announcement)
      response = Omnikassa2::OrderAnnounceRequest.new(order_announcement, config).send_request

      raise Omnikassa2::HttpError, response.to_s unless response.success?

      response
    end

    def status_pull(notification, &block)
      more_results_available = true
      while more_results_available
        raise Omnikassa2::InvalidSignatureError unless notification.valid_signature?(signing_key)
        raise Omnikassa2::ExpiringNotificationError if notification.expiring?

        response = Omnikassa2::StatusPullRequest.new(notification, config).send_request

        raise Omnikassa2::HttpError, response.to_s unless response.success?
        raise Omnikassa2::InvalidSignatureError unless response.valid_signature?(signing_key)

        result_set = response.order_result_set
        result_set.order_results.each(&block)

        more_results_available = result_set.more_order_results_available
      end
    end

    private

    def config
      {
        base_url: base_url,
        signing_key: signing_key,
        refresh_token: refresh_token
      }
    end
  end
end
