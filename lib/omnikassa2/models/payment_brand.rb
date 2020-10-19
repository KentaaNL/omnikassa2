# frozen_string_literal: true

module Omnikassa2
  # Payment brands (methods) possible values for the OmniKassa API.
  module PaymentBrand
    # paymentBrand: This field is optional and is used to enforce a specific payment method with the consumer
    # instead of the consumer selecting a payment method on the payment method selection page.
    # The CARDS value ensures that the consumer can choose between payment methods: MASTERCARD, VISA, BANCONTACT, MAESTRO and V_PAY.
    IDEAL = 'IDEAL'
    AFTERPAY = 'AFTERPAY'
    PAYPAL = 'PAYPAL'
    MASTER_CARD = 'MASTERCARD'
    VISA = 'VISA'
    BANCONTACT = 'BANCONTACT'
    MAESTRO = 'MAESTRO'
    V_PAY = 'V_PAY'
    CARDS = 'CARDS'

    # paymentBrandForce: This field should only be delivered if the paymentBrand field (see above) is also specified.
    # In the case of FORCE_ONCE, the indicated paymentBrand is only enforced on the first attempt.
    # If this fails, the consumer can still choose another payment method. When FORCE_ALWAYS is chosen,
    # the consumer is not allowed choose another payment method.
    FORCE_ONCE = 'FORCE_ONCE'
    FORCE_ALWAYS = 'FORCE_ALWAYS'
  end
end
