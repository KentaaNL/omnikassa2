describe Omnikassa2::RefreshRequest do
  it 'correctly sends request' do
    Omnikassa2API.stub(
      refresh_response: create(:refresh_response, token: 'myAccessToken')
    ) do
      request = Omnikassa2::RefreshRequest.new
      response = request.send
      expect(response.access_token.token).to eql('myAccessToken')
    end
  end
end
