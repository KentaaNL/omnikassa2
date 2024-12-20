# frozen_string_literal: true

require 'omnikassa2/requests/order_announce_request'
require 'time'

describe Omnikassa2::OrderAnnounceRequest do
  before do
    stub_request(:post, 'https://www.example.org/sandbox/order/server/api/v2/order').to_return(
      body: {
        signature: 's1gnaTuRe',
        redirectUrl: 'https://www.example.org/pay?token=S0meT0ken&?lang=nl'
      }.to_json
    )
  end

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

  let(:config) { ConfigurationFactory.create(signing_key: 'myS1gningK3y') }

  let(:minimal_merchant_order) do
    MerchantOrderFactory.create(
      base_params
    )
  end

  let(:merchant_order) do
    MerchantOrderFactory.create(
      base_params.merge(
        payment_brand: Omnikassa2::PaymentBrand::IDEAL,
        payment_brand_force: Omnikassa2::PaymentBrand::FORCE_ALWAYS
      )
    )
  end

  let(:minimal_order_announce_request) do
    Omnikassa2::OrderAnnounceRequest.new(
      minimal_merchant_order,
      config.merge(access_token: 'myAcCEssT0k3n')
    )
  end

  let(:order_announce_request) do
    Omnikassa2::OrderAnnounceRequest.new(
      merchant_order,
      config.merge(access_token: 'myAcCEssT0k3n')
    )
  end

  context 'when sent' do
    it 'only invokes one requests' do
      order_announce_request.send_request
      assert_requested :any, //, times: 1
    end

    it 'uses correct HTTP method' do
      order_announce_request.send_request
      assert_requested :post, //
    end

    it 'uses correct URL' do
      order_announce_request.send_request
      assert_requested :any, 'https://www.example.org/sandbox/order/server/api/v2/order'
    end

    it 'sets header: \'Content-Type: application/json\'' do
      order_announce_request.send_request
      assert_requested :any, //, headers: { 'Content-Type' => 'application/json' }
    end

    it 'sets header: \'Authorization: Bearer <access-token>\'' do
      order_announce_request.send_request
      assert_requested :any, //, headers: { 'Authorization' => 'Bearer myAcCEssT0k3n' }
    end

    describe 'request body' do
      it 'has timestamp' do
        Timecop.freeze Time.parse('2017-02-06T08:32:51.759+01:00')
        order_announce_request.send_request

        assert_requested(:any, //) do |request|
          JSON.parse(request.body)['timestamp'] == '2017-02-06T08:32:51.759+01:00'
        end
      end

      it 'has merchantOrderId' do
        order_announce_request.send_request

        assert_requested(:any, //) do |request|
          JSON.parse(request.body)['merchantOrderId'] == 'order123'
        end
      end

      it 'has amount.amount' do
        order_announce_request.send_request

        assert_requested(:any, //) do |request|
          JSON.parse(request.body)['amount']['amount'] == '4999'
        end
      end

      it 'has amount.currency' do
        order_announce_request.send_request

        assert_requested(:any, //) do |request|
          JSON.parse(request.body)['amount']['currency'] == 'EUR'
        end
      end

      it 'has merchantReturnURL' do
        order_announce_request.send_request

        assert_requested(:any, //) do |request|
          JSON.parse(request.body)['merchantReturnURL'] == 'http://www.example.org'
        end
      end

      it 'has paymentBrand' do
        order_announce_request.send_request

        assert_requested(:any, //) do |request|
          JSON.parse(request.body)['paymentBrand'] == Omnikassa2::PaymentBrand::IDEAL
        end
      end

      it 'has paymentBrandForce' do
        order_announce_request.send_request

        assert_requested(:any, //) do |request|
          JSON.parse(request.body)['paymentBrandForce'] == Omnikassa2::PaymentBrand::FORCE_ALWAYS
        end
      end
    end
  end
end
