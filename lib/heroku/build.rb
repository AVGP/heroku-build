require 'heroku/command/base'
require_relative 'source'

class Heroku::Command::Build < Heroku::Command::BaseWithApp
  def index
    tarball_path = ARGV[-1]
    display "Usage: heroku build <path/to/tarball>"
    display "Building #{app} from #{tarball_path}"
    source = Source.new(tarball_path, app, Heroku::Auth.password)
  end
end