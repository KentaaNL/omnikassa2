# Omnikassa2

This Gem provides the Ruby integration for the new OmniKassa 2.0 JSON API from the
Rabobank. The documentation for this API is currently here:
[Rabobank.nl](https://www.rabobank.nl/images/Handleiding_Rabo_OmniKassa_UK_29974797.pdf)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omnikassa2', git: 'https://github.com/KentaaNL/omnikassa2.git'
```

And then execute:

    $ bundle


## Configuration
You can find your `refresh_token` and `signing_key` in OmniKassa's dashboard. The `base_url` corresponds with the base_url of the OmniKassa 2.0 API. You can use `:sandbox` or `:production` as well.

```ruby
client = Omnikassa2::Client.new(
  refresh_token: 'my_refresh_token',
  signing_key: 'my_signing_key',
  base_url: :sandbox # Shortcut for 'https://betalen.rabobank.nl/omnikassa-api-sandbox'
)
```

For [Status Pull](#status-pull), it is required to configure a webhook as well (see official documentation).

## Announce order
```ruby
response = client.announce_order(
  Omnikassa2::MerchantOrder.new(
    merchant_order_id: 'order123',
    amount: Omnikassa2::Money.new(
      amount: 4999,
      currency: 'EUR'
    ),
    merchant_return_url: 'https://www.example.org/my-webshop'
  )
)

redirect_url = response.redirect_url

# Send client to 'redirect_url'
```

OmniKassa will now allow the user to pay. When the payment is finished or terminated, the user will be redirected to the given `merchant_return_url`. These query parameters are `order_id`, `status` and `signature`. We must validate the signature in order to trust the provided parameters:

```ruby
# pseudocode
class MyLandingPageController
  def get(request)
    params = request.params

    # Validate passed parameters
    valid_params = Omnikassa2::SignatureService.validate(
      params[:order_id] + ',' + params[:status],
      params[:signature],
      'my_signing_key'
    )

    if valid_params
      # Params are trusted
      render 'landing_page', order_status: params[:order_status]
    else
      # Params are not trusted
      render 'error_page'
    end
  end
end
```

## Status pull
Performing a status pull is only possible when notified by OmniKassa through a configured webhook in the dashboard.

```ruby
# pseudocode
class MyOmnikassaWebhookController
  def post(request)
    # Create notification object
    notification = Omnikassa2::Notification.from_json(request.raw_post)

    # Use notification object to retrieve statuses
    client.status_pull(notification) do |order_status|
      # Do something
      puts "Order: #{order_status.merchant_order_id}"
      puts "Paid amount: #{order_status.paid_amount.amount}"
    end
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/KentaaNL/omnikassa2.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
