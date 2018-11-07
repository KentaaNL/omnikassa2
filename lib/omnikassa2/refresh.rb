module Omnikassa2
 class Refresh

   def self.uri
     tmp_url = Omnikassa2.url + '/gatekeeper/refresh'
     URI(tmp_url)
   end

   def self.connect
     req = Net::HTTP::Get.new(uri)
     req['Authorization'] = "Bearer #{Omnikassa2.refresh_token}"
     res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
     return res.body
   end

 end
end
