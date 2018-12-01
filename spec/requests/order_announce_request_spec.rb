require 'omnikassa2/requests/order_announce_request'

describe Omnikassa2::OrderAnnounceRequest do
  before(:each) do
    Omnikassa2.config(
      ConfigurationFactory.create(
        base_url: 'https://www.example.com/sandbox'
      )
    )

    WebMock.stub_request(:post, "https://www.example.com/sandbox/order/server/api/order")
      .to_return(
        body: {
          signature: 's1gnaTuRe',
          redirectUrl:  "https://www.example.com/pay?token=S0meT0ken&?lang=nl"
        }.to_json
      )
  end

  let(:order_announce_request) do
    Omnikassa2::OrderAnnounceRequest.new(
      order: OrderFactory.create,
      access_token: 'myAcCEssT0k3n'
    )
  end

  context 'when sent' do
    it 'only invokes one requests' do
      order_announce_request.send
      assert_requested :any, //, times: 1
    end

    it 'uses correct HTTP method' do
      order_announce_request.send
      assert_requested :post, //
    end

    it 'uses correct URL' do
      order_announce_request.send
      assert_requested :any, 'https://www.example.com/sandbox/order/server/api/order'
    end

    it 'sets header: \'Content-Type: application/json\'' do
      order_announce_request.send
      assert_requested :any, //, headers: {'Content-Type' => 'application/json'}
    end

    it 'sets header: \'Authorization: Bearer <access-token>\'' do
      order_announce_request.send
      assert_requested :any, //, headers: {'Authorization' => 'Bearer myAcCEssT0k3n'}
    end

    # describe 'request body' do
    #   it 'has timestamp' do
    #     order_announce_request.send

    #     assert_requested(:any, //) do |req|
    #       binding.pry
    #       req.body == "abc"
    #     end
    #   end
    # end
  end
end
