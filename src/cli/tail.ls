{coroutine: async} = require \bluebird
through = require 'through2'
{cyan} = require \chalk
yargs = require \yargs
{tail} = require '../api/tail-build'
get-all-jobs = require '../api/get-all-jobs'
list-choice = require './list-choice'
{sort-abc} = require '../utils'
{filter, match: str-match, sort, is-empty} = require 'ramda'

error = (job-name, build-number) ->
  str = 'unable to find job'
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
      switch chunk.event
      | \GOT_BUILD         => cur-build := chunk.build
      | \WAITING_FOR_BUILD => push-line 'waiting for the next build...'

    next!

grep      = -> filter str-match new RegExp it, \i
grep-jobs = -> get-all-jobs! .then grep it

cli-tail = async (job-name, build-number, follow, second-time) ->*
  output = yield tail job-name, build-number, follow
  output.cata do
    Just: (output) ->
      output
        .pipe format-tail-output!
        .pipe process.stdout
        .on \end process.exit
    Nothing: async ->*
      jobs = sort-abc <| yield grep-jobs job-name
      unless is-empty jobs or second-time
        new-job-name = list-choice 'no such job, did you mean one of these?\n', jobs
        cli-tail new-job-name, build-number, follow, true
      else
        error job-name, build-number |> console.log

module.exports = cli-tail
