require "omnikassa2/version"
require "omnikassa2/refresh"
require "omnikassa2/announce"
require "omnikassa2/status"

require 'openssl'
require 'net/http'
require 'base64'

module Omnikassa2
  SETTINGS = :refresh_token, :signing_key, :environment, :merchant_return_url, :currency

  def self.config(settings)
    for setting in SETTINGS
      value = settings[setting.to_sym]
      raise ConfigError, "config setting '#{setting}' missing" if value.nil?

      class_variable_set '@@' + setting.to_s, value
    end
  end

  def self.set_access_token(token)
    class_variable_set '@@access_token', token
  end

  def self.access_token
    @@access_token
  end

  def self.refresh_token
    @@refresh_token
  end

  def self.signing_key
    Base64.decode64(@@signing_key)
  end

  def self.environment
    #@@environment || "sandbox"
    "sandbox"
  end

  def self.url
    if environment == 'production'
      "https://betalen.rabobank.nl/omnikassa-api"
    else
      "https://betalen.rabobank.nl/omnikassa-api-sandbox"
    end
  end

  def self.merchant_return_url
    @@merchant_return_url
  end

  def self.currency
    @@currency || "EUR"
  end

  # The common base class for all exceptions raised by OmniKassa
  class OmniKassaError < StandardError
  end

  # Raised if something is wrong with the configuration parameters
  class ConfigError < OmniKassaError
  end
end
