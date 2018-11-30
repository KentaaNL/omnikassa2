class Omnikassa2API
  @@mocking = false

  def self.stub(config = {})
    raise "Already in mocking context" if @@mocking
    @@config = config
    @mocking = true
    setup
    yield
    WebMock.reset!
    @mocking = false
  end

  private

  def self.setup
    Omnikassa2.config(
      refresh_token: 'reFresht0ken',
      base_url: 'https://www.example.com/sandbox',
      signing_key: 'sIgningK3y'
    )

    stub_refresh_requestion
  end

  def self.stub_refresh_requestion
    WebMock.stub_request(:get, "https://www.example.com/sandbox/gatekeeper/refresh")
      .with(body: nil, headers: {
        'Authorization' => 'Bearer reFresht0ken'
      })
      .to_return{ |request| refresh_response(request) }
  end

  def self.refresh_response(request)
    return handle_response request, :refresh_response do
      {
        body: {
          token: 'accEssT0ken',
          validUntil:  "2016-11-24T16:54:51.216+0000",
          durationInMillis: 28800000
        }.to_json
      }
    end
  end

  def self.handle_response(request, config_key)
    if(@@config.key?(config_key))
      handler = @@config[config_key]
      if(handler.respond_to? :call)
        handler.call(request)
      else
        handler
      end
    else
      yield
    end
  end
end
