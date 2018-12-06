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
      SignatureService.validate(to_s, @signature)
    end

    private

    def self.csv_serializer
      CSVSerializer.new([
        { field: :redirect_url }
      ])
    end
  end
end
