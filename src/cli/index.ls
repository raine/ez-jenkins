require! {
  '../api/tail-last-build'
  './tail'
  bluebird: Promise
  through2: through
  yargs
}

debug = require '../debug' <| __filename
async = Promise.coroutine

argv = require 'yargs'
  .usage 'Usage: jenkins <command> [options]'
  .command 'tail', 'read build logs'
  .option 'f',
    type        : \boolean
    description : "follow a job's build logs"
    alias       : \follow
  .help 'help', 'show help'
  .alias 'h', 'help'
  .argv

USAGE =
  tail: 'jenkins tail [-f] job-name'

print-usage-help = ->
  console.log "Usage: #{USAGE[it]}"
  process.exit!

switch argv._.0
| \tail     => tail argv
| otherwise => yargs.show-help!
