describe Omnikassa2 do
  describe 'status pull' do
    before(:each) do
      Timecop.freeze Time.parse('2016-11-24T17:30:00.000+0000')
    end

    context 'with expiring notification' do
      let(:expiring_notification) do
        NotificationFactory.create(
          expiry: Time.parse('2015-07-12T16:25:00.000+0000')
        )
      end

      it 'triggers error' do
        expect do
          Omnikassa2.status_pull(expiring_notification)
        end.to raise_error(Omnikassa2::ExpiringNotificationError)
      end
    end

    context 'with notification without valid signature' do
      let(:notification_with_invalid_signature) do
        NotificationFactory.create(
          signature: 'invalidSignature'
        )
      end

      it 'triggers error' do
        expect do
          Omnikassa2.status_pull(notification_with_invalid_signature)
        end.to raise_error(Omnikassa2::InvalidSignatureError)
      end
    end
  end
end
