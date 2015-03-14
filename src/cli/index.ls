yargs = require \yargs
parse = require './parse'

module.exports = (argv) ->
  {command, argv} = parse argv

  # TODO: considering handling pattern/job-name inside the command's handler
  switch command
  | \list
    pattern = argv._.1
    require './list' <| {pattern}
  | \tail
    job-name = argv._.1
    require './tail' <| {job-name, argv.build-number, argv.follow}
  | \setup
    (require './setup')!
  | \configure
    job-name = argv._.1
    require './configure' <| {job-name}
