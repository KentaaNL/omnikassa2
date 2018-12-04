class NotificationFactory
  def self.create(params = {})
    create_params = {
      authentication: params.fetch(:authentication, 'n0tificati0nT0ken'),
      expiry: params.fetch(:expiry, Time.parse('2016-11-25T09:53:46.123+01:00')),
      event_name: params.fetch(:event_name, 'merchant.order.status.changed'),
      poi_id: params.fetch(:poi_id, 123),
      signature: params.fetch(:signature, :valid_signature)
    }

    if(create_params.fetch(:signature) == :valid_signature)
      create_params[:signature] = Omnikassa2::SignatureProvider.sign(
        Omnikassa2::Notification.new(create_params).to_s
      )
    end

    Omnikassa2::Notification.new create_params
  end
end
