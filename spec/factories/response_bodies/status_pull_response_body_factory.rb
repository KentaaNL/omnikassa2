class StatusPullResponseBodyFactory
  def self.create(params = {})
    body = {
      signature: params.fetch(:signature, :valid_signature),
      moreOrderResultsAvailable: params.fetch(:moreOrderResultsAvailable, false),
      orderResults: params.fetch(:orders, [])
    }

    if(body.fetch(:signature) == :valid_signature)
      valid_signature = Omnikassa2::SignatureProvider.sign(
        Omnikassa2::OrderResultSet.from_json(JSON.generate(body)).to_s
      )
      body[:signature] = valid_signature
    end

    body
  end
end
