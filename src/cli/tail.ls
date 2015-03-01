{chalk} = require 'chalk'

format-line = (build, line) ->
  build-number = cyan "[##{build.number}]"
  "#build-number #line"

format-tail-output = ->
  var build

  through.obj (chunk, enc, cb) ->
    push-line = ~> @push new Buffer "#it\n"

    switch typeof! chunk
      | \String
        push-line format-line build, chunk
      | \Object
        switch chunk.event
        | \GOT_BUILD         => build := chunk.build
        | \WAITING_FOR_BUILD => push-line 'waiting for next build...'

    cb!

cli-tail = (argv) ->
  job-name = argv._.1
  print-usage-help \tail unless job-name

  do async ->*
    yield tail-last-build job-name, argv.follow
      ..cata do
        Just: (output) ->
          output
            .pipe format-tail-output!
            .pipe process.stdout
            .on \end process.exit
        Nothing: ->
          console.log "no such job: #job-name"

module.exports = cli-tail
