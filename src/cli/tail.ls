{coroutine: async} = require \bluebird
through = require 'through2'
{cyan} = require \chalk
yargs = require \yargs
tail-build = require '../api/tail-build'
get-all-jobs = require '../api/get-all-jobs'
list-choice = require './list-choice'
{sort-abc, die} = require '../utils'
{filter, match: str-match, sort, is-empty, curry-n, map, prop, take} = require 'ramda'
Maybe = require 'data.maybe'
debug = require '../debug' <| __filename
format-build-info = require './format-build-info'

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
      debug chunk, 'chunk'
      switch chunk.event
      | \GOT_BUILD         => cur-build := chunk.build
      | \WAITING_FOR_BUILD => push-line 'waiting for the next build...'
      | \BUILD_INFO        => push-line format-build-info chunk.build-info

    next!

fuzzy = curry-n 2, (require \fuzzy .filter)
grep-jobs = (str) ->
  get-all-jobs!
    .then fuzzy str
    .then map prop \string

suggest-jobs = async (str) ->*
  debug 'suggest-jobs str=%s', str
  jobs = yield grep-jobs str
  return Maybe
    .from-nullable (jobs unless is-empty jobs)
    .map take 10
    .map (jobs) ->
      list-choice 'no such job, did you mean one of these?\n', jobs

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
        print-err = -> error job-name, build-number |> console.log
        return print-err! if second-time

        new-job = yield suggest-jobs job-name
        new-job.cata do
          Just: (job-name) ->
            cli-tail {job-name, build-number, follow}, true
          Nothing: print-err
  catch
    die e

module.exports = cli-tail
