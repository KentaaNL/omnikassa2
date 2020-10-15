# frozen_string_literal: true

require 'omnikassa2/responses/base_response'

module Omnikassa2
  class StatusPullResponse < BaseResponse
    def to_csv
      csv_serializer.serialize(self)
    end

    def order_result_set
      OrderResultSet.from_json(json_body)
    end

    def valid_signature?(signing_key)
      order_result_set.valid_signature?(signing_key)
    end

    private

    def self.csv_serializer
      Omnikassa2::CSVSerializer.new([
        { field: :authentication },
        { field: :expiry },
        { field: :event_name },
        { field: :description }
      ])
    end
  end
end
