# frozen_string_literal: true

module Omnikassa2
  class BaseResponse
    attr_reader :body

    def initialize(http_response)
      @http_response = http_response
      @body = @http_response.body ? JSON.parse(@http_response.body) : nil
    end

    def json_body
      @http_response.body
    end

    def code
      @http_response.code.to_i
    end

    def message
      @http_response.message
    end

    def success?
      code >= 200 && code < 300
    end

    def to_s
      value = ''
      value += "Status: #{code}: #{message}\n"
      value += "Body: #{(body ? body.to_s : 'nil')}"
      value
    end
  end
end
