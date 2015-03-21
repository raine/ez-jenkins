readline-sync = require 'readline-sync'
config = require '../config'
{bold} = require 'chalk'

module.exports = !->
  """
  enter jenkins base url (abort with ^C)
  base url is the url of jenkins' main view
  """ |> console.log

  config.save url: readline-sync.prompt!

  """
  configuration written to #{config.path}
  ready to go!
  """ |> console.log
