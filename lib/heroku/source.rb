require "net/https"

class Source
    def initialize(tarball_path, app, api_key)
        @api_key = api_key
        url = URI.parse("https://#{api_key}@api.heroku.com/apps/#{app}/sources")

        req = Net::HTTP::Get.new(url.to_s)
        res = Net::HTTP.start(url.host, url.port) {|http|
          http.request(req)
        }
        puts res.body
    end
end