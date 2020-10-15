# frozen_string_literal: true

describe Omnikassa2::RefreshRequest do
  before(:each) do
    WebMock.stub_request(:any, //)
           .to_return(
             body: {
               token: 'myAccEssT0ken',
               validUntil:  '2016-11-24T16:54:51.216+0000',
               durationInMillis: 28_800_000
             }.to_json
           )
  end

  let(:config) { ConfigurationFactory.create(refresh_token: 'reFresht0ken') }

  context 'when sent' do
    it 'only invokes one requests' do
      Omnikassa2::RefreshRequest.new(config).send_request
      assert_requested :any, //, times: 1
    end

    it 'uses correct HTTP method' do
      Omnikassa2::RefreshRequest.new(config).send_request
      assert_requested :get, //
    end

    it 'uses correct URL' do
      Omnikassa2::RefreshRequest.new(config).send_request
      assert_requested :any, 'https://www.example.org/sandbox/gatekeeper/refresh'
    end

    it 'sets header: \'Authorization: Bearer <refresh-token>\'' do
      Omnikassa2::RefreshRequest.new(config).send_request
      assert_requested :any, //, headers: { 'Authorization' => 'Bearer reFresht0ken' }
    end

    describe 'returned response' do
      let(:returned_response) { Omnikassa2::RefreshRequest.new(config).send_request }

      describe 'access token' do
        let(:access_token) { returned_response.access_token }

        it 'contains token' do
          expect(access_token.token).to eql('myAccEssT0ken')
        end

        it 'contains valid_until' do
          expect(access_token.valid_until).to eql(Time.parse('2016-11-24T16:54:51.216+0000'))
        end

        it 'contains duration_in_millis' do
          expect(access_token.duration_in_millis).to eql(28_800_000)
        end
      end
    end
  end
end
