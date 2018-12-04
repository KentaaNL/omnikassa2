require 'omnikassa2/responses/base_response'

module Omnikassa2
  class OrderAnnounceResponse < BaseResponse
    def signature
      body['signature']
    end

    def redirect_url
      body['redirectUrl']
    end

    def valid_signature?
      SignatureProvider.validate(to_s, @signature)
    end

    def to_s
      Notification.csv_serializer.serialize(self)
    end

    private

    def self.csv_serializer
      CSVSerializer.new([
        { field: :redirect_url }
      ])
    end
  end
end
