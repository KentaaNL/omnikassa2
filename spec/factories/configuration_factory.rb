class ConfigurationFactory
  def self.create(params = {})
    {
      refresh_token: params.fetch(:refresh_token, 'reFresht0ken'),
      signing_key: params.fetch(:signing_key, 'sIgningK3y'),
      mode: :sandbox,
    }
  end
end
