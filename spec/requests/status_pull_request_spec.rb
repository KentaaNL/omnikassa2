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
      Omnikassa2::StatusPullRequest.new(notification_token).send
      assert_requested :any, //, times: 1
    end

    it 'uses correct HTTP method' do
      Omnikassa2::StatusPullRequest.new(notification_token).send
      assert_requested :get, //
    end

    it 'uses correct URL' do
      Omnikassa2::StatusPullRequest.new(notification_token).send
      assert_requested :any, 'https://www.example.org/sandbox/order/server/api/events/results/merchant.order.status.changed'
    end

    it 'sets header: \'Authorization: Bearer <refresh-token>\'' do
      Omnikassa2::StatusPullRequest.new(notification_token).send
      assert_requested :any, //, headers: {'Authorization' => 'Bearer n0tif1cationT0ken'}
    end

    context 'with expiring notification' do
      before(:each) do
        Timecop.freeze Time.parse('2016-11-24T17:30:00.000+0000')
      end

      subject do
        Omnikassa2::StatusPullRequest.new(
          NotificationFactory.create(
            expiry: Time.parse('2016-07-12T17:30:00.000+0000')
          )
        )
      end

      it 'triggers error' do
        expect { subject.send }.to raise_error(Omnikassa2::StatusPullRequest::ExpiringNotificationError)
      end
    end

    context 'with notification without valid signature' do
      subject do
        Omnikassa2::StatusPullRequest.new(
          NotificationFactory.create(
            signature: 'invalidSignature'
          )
        )
      end

      it 'triggers error' do
        expect { subject.send }.to raise_error(Omnikassa2::StatusPullRequest::InvalidSignatureError)
      end
    end
  end
end
