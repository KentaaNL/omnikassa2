# Omnikassa2

This Gem provides the Ruby on Rails integration for the new Omnikassa 2.0 JSON API from the
Rabobank. The documentation for this API is currently here:
[Rabobank.nl](https://www.rabobank.nl/images/handleiding-merchant-shop_29920545.pdf)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omnikassa2'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omnikassa2


## Usage

### Set environment variables

This gem reads it's config and tokens from environment variables. You have to
set at least the following:

* OMNIKASSA_REFRESH_TOKEN
* OMNIKASSA_SIGNING_KEY
* OMNIKASSA_CURRENCY
* OMNIKASSA_RETURN_URL

### Create initializer

Create an initializer in config/initializers/omnikassa.rb to read the
environment variables.

```ruby
if ENV['OMNIKASSA_REFRESH_TOKEN'].present?
  Omnikassa2.config(
    refresh_token:       ENV['OMNIKASSA_REFRESH_TOKEN'],
    signing_key:         ENV['OMNIKASSA_SIGNING_KEY'],
    currency:            ENV['OMNIKASSA_CURRENCY'],
    environment:         ENV['RAILS_ENV'],
    merchant_return_url: ENV['OMNIKASSA_RETURN_URL']
  )
end
````

### Create a route

You need a route to process the incoming Notify post from the Rabobank. They
call it Webhook-url in the Rabobank Dashboard. Set it to something like
yourapp.com/omnikassa and add this route to your routes file:

```ruby
    post 'omnikassa' => 'payments#omnikassa_notify'
```


## Development

Feel free to contact us if you need help implementing this Gem in your
application. Also let us know if you need additional features.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/omnikassa2.
