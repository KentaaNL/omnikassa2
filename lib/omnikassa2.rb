require "omnikassa2/version"
require 'openssl'
require 'net/http'
require 'base64'

module Omnikassa2
  @@configured = false

  SETTINGS = :refresh_token, :signing_key, :mode

  def self.config(settings)
    for setting in SETTINGS
      value = settings[setting.to_sym]
      raise ConfigError, "config setting '#{setting}' missing" if value.nil?

      class_variable_set '@@' + setting.to_s, value
    end

    @@configured = true
  end

  def self.configured?
    @@configured
  end

  def self.refresh_token
    @@refresh_token
  end

  def self.signing_key
    Base64.decode64(@@signing_key)
  end

  def self.base_url
    case @@mode
    when :production
      'https://betalen.rabobank.nl/omnikassa-api'
    when :sandbox
      'https://betalen.rabobank.nl/omnikassa-api-sandbox'
    else
      raise ConfigError, "unknown mode: '#{ @@mode }'"
    end
  end

  def self.announce_order(order_announcement)
    response = OrderAnnounceRequest.new(order_announcement, request_config).send
    raise Omnikassa2::InvalidSignatureError unless response.valid_signature?
    response
  end

  def self.status_pull(notification)
    more_results_available = true
    while(more_results_available) do
      response = StatusPullRequest.new(notification, request_config).send
      raise Omnikassa2::InvalidSignatureError unless response.valid_signature?

      result_set = response.order_result_set
      response.result_set.order_results.each do |order_result|
        yield order_result
      end

      more_results_available = result_set.more_order_results_available
    end
  end

  # The common base class for all exceptions raised by OmniKassa
  class OmniKassaError < StandardError
  end

  # Raised if something is wrong with the configuration parameters
  class ConfigError < OmniKassaError
  end

  class InvalidSignatureError < OmniKassaError
  end

  class ExpiringNotificationError < OmniKassaError
  end

  private

  def request_config
    {
      access_token: AccessTokenProvider.instance
    }
  end
end
