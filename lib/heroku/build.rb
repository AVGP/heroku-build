require 'heroku/command/base'
require "net/https"
require "json"

require_relative 'source'

class Heroku::Command::Build < Heroku::Command::BaseWithApp
  def index
    tarball_path = args.shift
    version = args.shift
    if tarball_path.nil? || version.nil?
      display "Usage: heroku build <path/to/tarball> <version>"
      return
    end

    display "Building #{app} #{version} from #{tarball_path}"
    source = Source.new(app, Heroku::Auth.password)
    tarball_url = source.upload(tarball_path)
    make_build_from_url(tarball_url, version)
  end

  def src
    src = options[:src]
  end

  private

  def make_build_from_url(tar_url, version)
    url = URI.parse("https://api.heroku.com/apps/#{app}/builds")

    req = Net::HTTP::Post.new(url.request_uri)
    req.add_field("Accept", "application/vnd.heroku+json; version=3")
    req.add_field("Authorization", "Bearer #{Heroku::Auth.password}")
    req.add_field("Content-Type", "application/json")
    req.body = "#{ { source_blob: { url: tar_url, version: version}}.to_json }"

    res = Net::HTTP.start(url.host, url.port, nil, nil, nil, nil, {use_ssl: true}) {|http|
      http.request(req)
    }

    puts res.body
    puts "Build created."

  end
end
