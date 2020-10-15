# frozen_string_literal: true

describe Omnikassa2::SignatureService do
  let(:config) { ConfigurationFactory.create(signing_key: 'myS1gningK3y') }

  it 'uses correct key and algorithm to create signature' do
    actual_hash = Omnikassa2::SignatureService.sign('Hello World', config[:signing_key])
    expected_hash = 'a174ef487299059911a6ee59bd78236bcf55af52ca67c6e8ac024d2bf3437334a8143b8017fbac9d381a19e6037d5b587d3280506733315860bdae18c70142fd'
    expect(actual_hash).to eq(expected_hash)
  end
end
