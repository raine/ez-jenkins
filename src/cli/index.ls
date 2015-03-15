require! yargs
require! './parse'
require! ramda: {is-empty, join}

concat-args = (argv) ->
  args = argv._.slice 1
  unless is-empty args
    join '', args

module.exports = (argv) ->
  {command, argv} = parse argv
  args = concat-args argv

  switch command
  | \list
    require './list' <| {input: args}
  | \tail
    require './tail' <| {job-name: args, argv.build-number, argv.follow}
  | \setup
    (require './setup')!
  | \configure
    require './configure' <| {job-name: args}
