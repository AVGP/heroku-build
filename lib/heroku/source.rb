require "net/https"

class Source
    def initialize(tarball_path, app, api_key)
        @api_key = api_key
        url = URI.parse("https://#{api_key}@api.heroku.com/apps/#{app}/sources")

        req = Net::HTTP::Post.new(url.request_uri)
        req.add_field("Accept", "application/vnd.heroku+json; version=3")
        req.add_field("Authorization", "Bearer #{api_key}")

        res = Net::HTTP.start(url.host, url.port, nil, nil, nil, nil, {use_ssl: true}) {|http|
          http.request(req)
        }
        puts res.body
    end
end