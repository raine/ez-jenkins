Promise = require \bluebird
async   = Promise.coroutine
through = require 'through2'
{cyan}  = require \chalk
{tail}  = require '../api/tail-build'

format-line = (build, line) ->
  build-number = cyan "[##{build.number}]"
  "#build-number #line"

format-tail-output = ->
  var cur-build

  through.obj (chunk, enc, cb) ->
    push-line = ~> @push new Buffer "#it\n"

    switch typeof! chunk
      | \String
        push-line format-line cur-build, chunk
      | \Object
        switch chunk.event
        | \GOT_BUILD         => cur-build := chunk.build
        | \WAITING_FOR_BUILD => push-line 'waiting for the next build...'

    cb!

cli-tail = async (argv) ->*
  job-name = argv._.1
  print-usage-help \tail unless job-name

  output = yield tail job-name, argv.build, argv.follow
  output.cata do
    Just: (output) ->
      output
        .pipe format-tail-output!
        .pipe process.stdout
        .on \end process.exit
    Nothing: ->
      console.log "no such job: #job-name"

module.exports = cli-tail
