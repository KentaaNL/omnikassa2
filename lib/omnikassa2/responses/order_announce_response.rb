require 'omnikassa2/responses/base_response'

module Omnikassa2
  class OrderAnnounceResponse < BaseResponse
    def signature
      body['signature']
    end

    def redirect_url
      body['redirectUrl']
    end
  end
end
