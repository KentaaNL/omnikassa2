require 'omnikassa2/requests/base_request'
require 'omnikassa2'

module Omnikassa2
  class StatusPullRequest < BaseRequest
    def initialize(notification, config = {})
      super(config)

      @notification = notification
    end

    def http_method
      :get
    end

    def authorization_method
      :custom_token
    end

    def custom_token
      @notification.authentication
    end

    def path
      '/order/server/api/events/results/merchant.order.status.changed'
    end

    def response_decorator
      StatusPullResponse
    end

    def send
      raise InvalidSignatureError unless @notification.valid_signature?
      raise ExpiringNotificationError if @notification.expiring?

      super()
    end

    class StatusPullRequestError < ::Omnikassa2::OmniKassaError
    end

    class InvalidSignatureError < StatusPullRequestError
    end

    class ExpiringNotificationError < StatusPullRequestError
    end
  end
end
