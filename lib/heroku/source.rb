require "net/https"
require "json"

#
# Talks to the /sources API endpoint
# to create two URLs to deal with the source tarball
# 1.) PUT URL to upload the tarball
# 2.) GET URL to use for creating a build
class Source
    def initialize(app_name, api_key)
        puts "Acquiring source URL..."
        url = URI.parse("https://#{api_key}@api.heroku.com/apps/#{app_name}/sources")

        req = Net::HTTP::Post.new(url.request_uri)
        req.add_field("Accept", "application/vnd.heroku+json; version=3")
        req.add_field("Authorization", "Bearer #{api_key}")

        res = Net::HTTP.start(url.host, url.port, nil, nil, nil, nil, {use_ssl: true}) {|http|
            http.request(req)
        }

        @urls = JSON.parse(res.body)

        if @urls['source_blob'].nil?
            raise "Error! Source URL was not returned from Heroku! Response: #{res.body}"
        end

        @urls = @urls['source_blob']

        puts "Source URL for upload is #{@urls['put_url']}"

    end

    def upload(tarball_path)
        puts "Uploading tarball..."

        url = URI.parse(@urls['put_url'])
        req = Net::HTTP::Put.new(url.request_uri)
        req.body_stream = File.open(tarball_path)
        req.add_field("Content-Type", "")
        req.add_field("Content-Length", File.size(tarball_path))

        res = Net::HTTP.start(url.host, url.port, nil, nil, nil, nil, {use_ssl: true}) {|http|
            http.request(req)
        }

        puts res.body
        puts "Source URL for download is #{@urls['get_url']}"

        return @urls['get_url']
    end
end
