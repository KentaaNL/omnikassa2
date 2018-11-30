require 'omnikassa2/responses/json_response'

module Omnikassa2
  class RefreshResponse < JSONResponse
    def access_token
      AccessToken.from_json(json_body)
    end
  end
end
