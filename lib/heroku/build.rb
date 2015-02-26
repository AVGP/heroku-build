require 'heroku/command/base'

class Heroku::Command::Build < Heroku::Command::BaseWithApp
  def index
    display "Usage: heroku build"
  end
end