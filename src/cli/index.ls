yargs = require \yargs
parse = require './parse'

module.exports = (argv) ->
  {command, argv} = parse argv

  switch command
  | \tail
    return yargs.show-help! unless argv._.1
    require('./tail') argv._.1, argv.build, argv.follow
  | \setup
    require('./setup')!
