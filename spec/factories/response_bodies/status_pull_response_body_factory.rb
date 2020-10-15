# frozen_string_literal: true

class StatusPullResponseBodyFactory
  def self.create(params, config)
    body = {
      signature: params.fetch(:signature, :valid_signature),
      moreOrderResultsAvailable: params.fetch(:moreOrderResultsAvailable, false),
      orderResults: params.fetch(:orders, [])
    }

    if body.fetch(:signature) == :valid_signature
      valid_signature = Omnikassa2::SignatureService.sign(
        Omnikassa2::OrderResultSet.from_json(JSON.generate(body)).to_s,
        config[:signing_key]
      )
      body[:signature] = valid_signature
    end

    body
  end
end
