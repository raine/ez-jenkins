readline-sync = require 'readline-sync'
config = require '../config'

module.exports = ->
  "enter url to jenkins or abort with ^C" |> console.log
  config.save url: readline-sync.prompt!
  "configuration written to #{config.config-path}" |> console.log
