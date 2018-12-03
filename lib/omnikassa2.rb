require "omnikassa2/version"
require 'openssl'
require 'net/http'
require 'base64'

module Omnikassa2
  SETTINGS = :refresh_token, :signing_key, :base_url

  def self.config(settings)
    for setting in SETTINGS
      value = settings[setting.to_sym]
      raise ConfigError, "config setting '#{setting}' missing" if value.nil?

      class_variable_set '@@' + setting.to_s, value
    end
  end

  def self.refresh_token
    @@refresh_token
  end

  def self.signing_key
    Base64.decode64(@@signing_key)
  end

  def self.base_url
    @@base_url
  end

  # The common base class for all exceptions raised by OmniKassa
  class OmniKassaError < StandardError
  end

  # Raised if something is wrong with the configuration parameters
  class ConfigError < OmniKassaError
  end
end
