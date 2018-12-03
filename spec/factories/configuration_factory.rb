class ConfigurationFactory
  def self.create(params = {})
    {
      refresh_token: params.fetch(:refresh_token, 'reFresht0ken'),
      base_url: params.fetch(:base_url, 'https://www.example.org/sandbox'),
      signing_key: params.fetch(:signing_key, 'sIgningK3y')
    }
  end
end
