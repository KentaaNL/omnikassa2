# frozen_string_literal: true

RSpec.describe Omnikassa2::Client do
  subject(:client) { described_class.new(signing_key: config[:signing_key], refresh_token: config[:refresh_token]) }

  let(:config) { ConfigurationFactory.create }

  describe '#announce_order' do
    let(:base_params) do
      {
        merchant_order_id: 'order123',
        amount: Omnikassa2::Money.new(
          amount: 4999,
          currency: 'EUR'
        ),
        merchant_return_url: 'http://www.example.org'
      }
    end

    let(:merchant_order) do
      MerchantOrderFactory.create(
        base_params.merge(
          payment_brand: Omnikassa2::PaymentBrand::IDEAL,
          payment_brand_force: Omnikassa2::PaymentBrand::FORCE_ALWAYS
        )
      )
    end

    context 'when API returns HTTP 500' do
      before do
        stub_request(:get, 'https://betalen.rabobank.nl/omnikassa-api/gatekeeper/refresh')
          .to_return(
            status: 200,
            body: {
              token: 'myAccEssT0ken',
              validUntil: '2099-12-31T23:59:59.999+0000',
              durationInMillis: 28_800_000
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        stub_request(:post, 'https://betalen.rabobank.nl/omnikassa-api/order/server/api/v2/order')
          .to_return(status: 500, body: 'Internal Server Error')
      end

      it 'raises an HttpError' do
        expect { client.announce_order(merchant_order) }.to raise_error(Omnikassa2::HttpError)
      end
    end

    context 'when request times out' do
      before do
        stub_request(:get, 'https://betalen.rabobank.nl/omnikassa-api/gatekeeper/refresh').to_timeout
      end

      it 'raises a ConnectionError' do
        expect { client.announce_order(merchant_order) }.to raise_error(Omnikassa2::ConnectionError) do |exception|
          expect(exception.message).to eq('execution expired')
          expect(exception.cause).to be_a(Net::OpenTimeout)
        end
      end
    end
  end

  describe '#status_pull' do
    before do
      Timecop.freeze Time.parse('2016-11-24T17:30:00.000+0000')
    end

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
