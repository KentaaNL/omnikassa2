describe Omnikassa2::SignatureProvider do
  before(:each) do
    Omnikassa2.config(
      ConfigurationFactory.create(
        signing_key: 'bXlTMWduaW5nSzN5' # Base64.encode64('myS1gningK3y')
      )
    )
  end

  def hash(value)
    case value
    when 'Hello World'
      'a174ef487299059911a6ee59bd78236bcf55af52ca67c6e8ac024d2bf3437334a8143b8017fbac9d381a19e6037d5b587d3280506733315860bdae18c70142fd'
    when 'Hello World,123'
      '3642aa81fe881e49d8c9b7adf135d36618a76188310a6d80617e4c51b8af69adb3c7d70d0f102a755bcc907b38d824c7637c24bd267f0d388c83b00c7851c776'
    when 'Hello World,'
      '0a904fb017269e2032b267153eeef6bf42051052742c34659898a8ff882c2abdc3b68ac0a47e4446b662fe6b5a98aa454f04becca5b031e80f174a3abe51e388'
    else
      raise "No test hash available for value '#{value}'"
    end
  end

  it 'signs single value' do
    provider = Omnikassa2::SignatureProvider.new([
      { name: :field_one }
    ])

    signature = provider.sign({
      field_one: 'Hello World'
    })

    expect(signature).to eq(hash('Hello World'))
  end

  it 'ingores unconfigured fields' do
    provider = Omnikassa2::SignatureProvider.new([
      { name: :field_one }
    ])

    signature = provider.sign({
      field_one: 'Hello World',
      unconfigured_field: 'Something'
    })

    expect(signature).to eq(hash('Hello World'))
  end

  it 'signs multiple values' do
    provider = Omnikassa2::SignatureProvider.new([
      { name: :field_one },
      { name: :field_two }
    ])

    signature = provider.sign({
      field_one: 'Hello World',
      field_two: 123
    })

    expect(signature).to eq(hash('Hello World,123'))
  end

  it 'respects the order of the fields passed in config' do
    provider = Omnikassa2::SignatureProvider.new([
      { name: :field_one },
      { name: :field_two }
    ])

    signature = provider.sign({
      field_two: 123,
      field_one: 'Hello World'
    })

    expect(signature).to eq(hash('Hello World,123'))
  end

  it 'does not include nil values for fields without \'include_if_empty: true\'' do
    provider = Omnikassa2::SignatureProvider.new([
      { name: :field_one },
      { name: :field_two }
    ])

    signature = provider.sign({
      field_one: 'Hello World',
      field_two: nil
    })

    expect(signature).to eq(hash('Hello World'))
  end

  it 'does not include nil values for fields with \'include_if_empty: true\'' do
    provider = Omnikassa2::SignatureProvider.new([
      { name: :field_one },
      { name: :field_two, include_if_empty: true }
    ])

    signature = provider.sign({
      field_one: 'Hello World',
      field_two: nil
    })

    expect(signature).to eq(hash('Hello World,'))
  end
end
