describe Omnikassa2::RefreshRequest do
  before(:all) do
    Omnikassa2.config(
      refresh_token: 'reFresht0ken',
      base_url: 'https://www.example.com/sandbox',
      signing_key: 'sIgningK3y'
    )

    stub_request(:get, "https://www.example.com/sandbox/gatekeeper/refresh")
      .with(body: nil, headers: {
        'Authorization' => 'Bearer reFresht0ken'
      })
      .to_return(
        body: {
          token: 'accEssT0ken',
          validUntil:  "2016-11-24T16:54:51.216+0000",
          durationInMillis: 28800000
        }.to_json
      )
  end

  it 'correctly sends request' do
    request = Omnikassa2::RefreshRequest.new
    response = request.send
    expect(response.access_token.token).to eql('accEssT0ken')
  end
end
