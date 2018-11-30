class RefreshResponseFactory
  def self.create(params = {})
    {
      body: {
        token: params.fetch(:token, 'accEssT0ken'),
        validUntil:  params.fetch(:valid_until, "2016-11-24T16:54:51.216+0000"),
        durationInMillis: params.fetch(:duration_in_millis, 28800000)
      }.to_json
    }
  end
end
