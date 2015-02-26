require 'heroku/command/base'
require "net/https"
require "json"

require_relative 'source'

class Heroku::Command::Build < Heroku::Command::BaseWithApp
  def index
    tarball_path = option[:src]
    version = option[:version]
    display "Usage: heroku build <path/to/tarball>"
    display "Building #{app} from #{tarball_path}"
    source = Source.new(app, Heroku::Auth.password)
    source_url = source.upload(tarball_path)
    make_build_from_url(source_url, version)
  end

  private

  def make_build_from_url(url, version)
    url = URI.parse("https://api.heroku.com/apps/#{app}/builds")

    req = Net::HTTP::Post.new(url.request_uri)
    req.add_field("Accept", "application/vnd.heroku+json; version=3")
    req.add_field("Authorization", "Bearer #{Heroku::Auth.password}")
    req.body = "[ #{ { source_blob: { url: url, version: version}}.to_json } ]"

    res = Net::HTTP.start(url.host, url.port, nil, nil, nil, nil, {use_ssl: true}) {|http|
      http.request(req)
    }

    puts res.body
    puts "Build created."

  end
end