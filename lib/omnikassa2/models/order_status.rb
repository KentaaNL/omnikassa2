# frozen_string_literal: true

module Omnikassa2
  # Order status possible values for the OmniKassa API.
  module OrderStatus
    # Successful payment of the order.
    COMPLETED = 'COMPLETED'

    # The consumer has not paid within the stipulated period.
    EXPIRED = 'EXPIRED'

    # The payment has not yet been completed.
    # This can occur as a result of a breakdown or delay in the hinterland of payment processing.
    # This is a possible outcome of an iDEAL or credit card payment.
    IN_PROGRESS = 'IN_PROGRESS'

    # The consumer chose not to pay and cancelled the order.
    CANCELLED = 'CANCELLED'
  end
end
