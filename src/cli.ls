require! {
  yargs
  './api/tail'
  bluebird: Promise
}

debug = require './debug' <| __filename
async = Promise.coroutine

argv = require 'yargs'
  .usage 'Usage: $0 <command> [options]'
  .command 'tail', 'read build logs'
  .command 'list', 'list builds'
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

  do async ->*
    rs = yield tail job-name
    rs.pipe process.stdout
    rs.on 'end', ->
      console.log 'done'
      process.exit!

default
  yargs.show-help!
