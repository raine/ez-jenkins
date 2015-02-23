require! {
  yargs
  './api/tail-last-build'
  bluebird: Promise
}

debug = require './debug' <| __filename
async = Promise.coroutine

argv = require 'yargs'
  .usage 'Usage: $0 <command> [options]'
  .command 'tail', 'read build logs'
  .option 'f', 
    type        : \boolean
    description : "follow a job's build logs"
    alias       : \follow
  .help 'help', 'show help'
  .example 'jenkins tail my-funny-build -f'
  .argv

switch argv._.0
case \tail
  job-name = argv._.1

  unless job-name
    console.log 'Usage: jenkins tail [job-name]'
    process.exit!

  # TODO: build number
  # TODO: follow after build ends
  # TODO: move somewhere
  tail-cmd = async (job-name, follow) ->*
    build = yield tail-last-build job-name
    build.stream.pipe process.stdout
    build.stream.on \end ->
      console.log "that's all folks"

  tail-cmd job-name, true

default
  yargs.show-help!
