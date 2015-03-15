{curry} = require 'ramda'

{coroutine: async} = require \bluebird
through = require 'through2'
{cyan} = require \chalk
yargs = require \yargs
tail-build = require '../api/tail-build'
get-all-jobs = require '../api/get-all-jobs'
{sort-abc, die} = require '../utils'
list-choice = curry require './list-choice'
Maybe = require 'data.maybe'
debug = require '../debug' <| __filename
format-build-info = require './format-build-info'
{fuzzy-filter, format-jobs-table} = require '../utils'

error = (job-name, build-number) ->
  str = 'Unable to find job'
  switch
  | build-number? => "#str or build: #job-name [##{build-number}]"
  | otherwise     => "#str: #job-name"

format-line = (build, line) ->
  build-number = cyan "[##{build.number}]"
  "#build-number #line"

format-tail-output = ->
  var cur-build

  through.obj (chunk, enc, next) ->
    push-line = ~> @push new Buffer "#it\n"

    switch typeof! chunk
    | \String
      push-line format-line cur-build, chunk
    | \Object
      debug chunk, 'chunk'
      switch chunk.event
      | \GOT_BUILD         => cur-build := chunk.build
      | \WAITING_FOR_BUILD => push-line 'Waiting for the next build...'
      | \BUILD_INFO        => push-line format-build-info chunk.build-info

    next!

cli-tail = async (opts, second-time) ->*
  {job-name, build-number, follow} = opts

  try
    output = yield tail-build job-name, build-number, follow
    output.cata do
      Just: (output) ->
        output
          .pipe format-tail-output!
          .pipe process.stdout
      Nothing: async ->*
        print-err = -> error job-name, build-number |> console.error
        return print-err! if second-time

        (fuzzy-filter job-name, yield get-all-jobs!)
          .map list-choice 'No such job, did you mean one of these?\n'
          .cata do
            Just: (job-name) ->
              cli-tail {job-name, build-number, follow}, true
            Nothing: print-err
  catch
    die e

module.exports = cli-tail
