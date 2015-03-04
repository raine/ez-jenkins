yargs = require \yargs
parse = require './parse'

module.exports = (argv) ->
  {command, argv} = parse argv

  switch command
  | \tail
    job-name = argv._.1
    return yargs.show-help! unless job-name
    require('./tail') {job-name, argv.build-number, argv.follow}
  | \setup
    require('./setup')!
