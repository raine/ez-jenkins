require! yargs
require! './parse'
require! ramda: {join}

concat-args = (argv) ->
  join '', argv._.slice 1

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
