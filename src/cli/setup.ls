readline-sync = require 'readline-sync'
config = require '../config'
{inverse} = require 'chalk'

module.exports = ->
  """
  enter jenkins base url (abort with ^C)

  #{bold 'http://ci.example.com/'}job/test-job-1234
  └───── base url ─────┘

  """ |> console.log

  config.save url: readline-sync.prompt!
  "configuration written to #{config.config-path}" |> console.log
