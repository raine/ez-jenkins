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

USAGE =
  tail: 'jenkins tail [job-name]'

usage-help = ->
  console.log "Usage: #{USAGE[it]}"
  process.exit!

switch argv._.0
| 'tail'
  job-name = argv._.1

  unless job-name
    usage-help \tail
    process.exit!

  do async ->*
    output = yield tail-last-build job-name, argv.follow
    output.pipe process.stdout
    output.on \end process.exit

| otherwise
  yargs.show-help!
