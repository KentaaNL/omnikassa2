require 'omnikassa2/responses/refresh_response'

class Omnikassa2::RefreshRequest
  def send
    req = Net::HTTP::Get.new(uri)

    req['Authorization'] = "Bearer #{Omnikassa2.refresh_token}"

    http_response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
    Omnikassa2::RefreshResponse.new(http_response)
  end

  private

  def uri
    tmp_url = Omnikassa2.base_url + '/gatekeeper/refresh'
    URI(tmp_url)
  end
end
