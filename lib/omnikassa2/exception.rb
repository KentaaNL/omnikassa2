# frozen_string_literal: true

module Omnikassa2
  # The common base class for all exceptions raised by OmniKassa
  class OmniKassaError < StandardError
  end

  class InvalidSignatureError < OmniKassaError
  end

  class ExpiringNotificationError < OmniKassaError
  end

  class HttpError < OmniKassaError
  end
end
