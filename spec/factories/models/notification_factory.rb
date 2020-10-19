# frozen_string_literal: true

module NotificationFactory
  module_function

  def create(params, config)
    create_params = {
      authentication: params.fetch(:authentication, 'n0tificati0nT0ken'),
      expiry: params.fetch(:expiry, Time.parse('2016-11-25T09:53:46.123+01:00')),
      event_name: params.fetch(:event_name, 'merchant.order.status.changed'),
      poi_id: params.fetch(:poi_id, 123),
      signature: params.fetch(:signature, :valid_signature)
    }

    if create_params.fetch(:signature) == :valid_signature
      create_params[:signature] = Omnikassa2::SignatureService.sign(
        Omnikassa2::Notification.new(create_params).to_s,
        config[:signing_key]
      )
    end

    Omnikassa2::Notification.new(create_params)
  end
end
