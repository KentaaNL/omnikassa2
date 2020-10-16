# frozen_string_literal: true

class ConfigurationFactory
  def self.create(params = {})
    {
      refresh_token: params.fetch(:refresh_token, 'reFresht0ken'),
      signing_key: params.fetch(:signing_key, 'sIgningK3y'),
      base_url: 'https://www.example.org/sandbox'
    }
  end
end
