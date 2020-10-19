# frozen_string_literal: true

describe Omnikassa2::Client do
  describe '#status_pull' do
    before(:each) do
      Timecop.freeze Time.parse('2016-11-24T17:30:00.000+0000')
    end

    let(:config) { ConfigurationFactory.create }
    let(:client) { Omnikassa2::Client.new(signing_key: config[:signing_key], refresh_token: config[:refresh_token]) }

    context 'with expiring notification' do
      let(:expiring_notification) do
        NotificationFactory.create(
          { expiry: Time.parse('2015-07-12T16:25:00.000+0000') },
          config
        )
      end

      it 'triggers an error' do
        expect { client.status_pull(expiring_notification) }.to raise_error(Omnikassa2::ExpiringNotificationError)
      end
    end

    context 'with notification without valid signature' do
      let(:notification_with_invalid_signature) do
        NotificationFactory.create(
          { signature: 'invalidSignature' },
          config
        )
      end

      it 'triggers an error' do
        expect { client.status_pull(notification_with_invalid_signature) }.to raise_error(Omnikassa2::InvalidSignatureError)
      end
    end
  end
end
