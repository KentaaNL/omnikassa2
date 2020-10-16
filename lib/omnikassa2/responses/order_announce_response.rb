# frozen_string_literal: true

require 'omnikassa2/responses/base_response'

module Omnikassa2
  class OrderAnnounceResponse < BaseResponse
    def omnikassa_order_id
      body[:omnikassaOrderId]
    end

    def redirect_url
      body[:redirectUrl]
    end

    def to_s
      OrderAnnounceResponse.csv_serializer.serialize(self)
    end

    def self.csv_serializer
      CSVSerializer.new([
        { field: :redirect_url },
        { field: :omnikassa_order_id }
      ])
    end
  end
end
