require! {
  yargs
  bluebird: Promise
  './api/tail-last-build'
}

debug = require './debug' <| __filename
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
| 'tail'
  job-name = argv._.1
  print-usage-help \tail unless job-name

  do async ->*
    yield tail-last-build job-name, argv.follow
      ..cata do
        Just: ->
          it.pipe process.stdout
            .on \end process.exit
        Nothing: ->
          console.log "no such job: #job-name"

| otherwise
  yargs.show-help!
