readline-sync = require 'readline-sync'
config = require '../config'
{bold} = require 'chalk'

module.exports = ->
  """
  enter jenkins base url (abort with ^C)

  http://ci.example.com/job/test-job-1234
  └───── base url ─────┘

  """ |> console.log

  config.save url: readline-sync.prompt!

  """
  configuration written to #{config.path}
  ready to go!
  """ |> console.log
