describe Omnikassa2::StatusPullRequest do
  before(:each) do
    Omnikassa2.config(
      ConfigurationFactory.create(
        base_url: 'https://www.example.org/sandbox'
      )
    )

    WebMock.stub_request(:any, //)
      .to_return(
        body: StatusPullResponseBodyFactory.create(
          signature: :valid_signature,
          moreOrderResultsAvailable: false,
          orderResults:  []
        ).to_json
      )
  end

  let(:notification_token) {
    NotificationFactory.create(
      authentication: 'n0tif1cationT0ken'
    )
  }

  context 'when sent' do
    it 'only invokes one requests' do
      Omnikassa2::StatusPullRequest.new(notification_token).send_request
      assert_requested :any, //, times: 1
    end

    it 'uses correct HTTP method' do
      Omnikassa2::StatusPullRequest.new(notification_token).send_request
      assert_requested :get, //
    end

    it 'uses correct URL' do
      Omnikassa2::StatusPullRequest.new(notification_token).send_request
      assert_requested :any, 'https://www.example.org/sandbox/order/server/api/events/results/merchant.order.status.changed'
    end

    it 'sets header: \'Authorization: Bearer <refresh-token>\'' do
      Omnikassa2::StatusPullRequest.new(notification_token).send_request
      assert_requested :any, //, headers: {'Authorization' => 'Bearer n0tif1cationT0ken'}
    end
  end
end
