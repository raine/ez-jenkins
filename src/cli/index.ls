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
    job-name = argv._.1
    require './tail' <| {job-name, argv.build-number, argv.follow}
  | \setup
    (require './setup')!
  | \configure
    job-name = argv._.1
    require './configure' <| {job-name}
