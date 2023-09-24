require "spectator"
require "../src/*"

Spectator.configure do |config|
  config.fail_blank
  config.randomize
end
