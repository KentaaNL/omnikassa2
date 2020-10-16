# frozen_string_literal: true

describe Omnikassa2::StatusPullRequest do
  before(:each) do
    stub_request(:any, //).to_return(
      body: StatusPullResponseBodyFactory.create(
        {
          signature: :valid_signature,
          moreOrderResultsAvailable: false,
          orderResults: []
        },
        config
      ).to_json
    )
  end

  let(:notification_token) do
    NotificationFactory.create(
      { authentication: 'n0tif1cationT0ken' },
      config
    )
  end

  let(:config) { ConfigurationFactory.create }

  context 'when sent' do
    it 'only invokes one requests' do
      Omnikassa2::StatusPullRequest.new(notification_token, config).send_request
      assert_requested :any, //, times: 1
    end

    it 'uses correct HTTP method' do
      Omnikassa2::StatusPullRequest.new(notification_token, config).send_request
      assert_requested :get, //
    end

    it 'uses correct URL' do
      Omnikassa2::StatusPullRequest.new(notification_token, config).send_request
      assert_requested :any, 'https://www.example.org/sandbox/order/server/api/events/results/merchant.order.status.changed'
    end

    it 'sets header: \'Authorization: Bearer <refresh-token>\'' do
      Omnikassa2::StatusPullRequest.new(notification_token, config).send_request
      assert_requested :any, //, headers: { 'Authorization' => 'Bearer n0tif1cationT0ken' }
    end
  end
end
