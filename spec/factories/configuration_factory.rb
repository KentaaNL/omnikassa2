# frozen_string_literal: true

module ConfigurationFactory
  module_function

  def create(params = {})
    {
      refresh_token: params.fetch(:refresh_token, 'reFresht0ken'),
      signing_key: Base64.encode64(params.fetch(:signing_key, 'sIgningK3y')),
      base_url: 'https://www.example.org/sandbox'
    }
  end
end
