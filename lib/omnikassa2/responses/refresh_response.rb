# frozen_string_literal: true

require 'omnikassa2/responses/base_response'

module Omnikassa2
  class RefreshResponse < BaseResponse
    def access_token
      AccessToken.from_json(json_body)
    end
  end
end
