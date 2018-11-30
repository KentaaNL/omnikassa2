module Omnikassa2
  class JSONResponse
    def initialize(http_response)
      @http_response = http_response
      @body = JSON.parse(@http_response.body)
    end

    def json_body
      @http_response.body
    end

    def body
      @body
    end
  end
end
