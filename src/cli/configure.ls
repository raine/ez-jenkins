{curry} = require 'ramda'
{coroutine: async} = require \bluebird
debug = require '../debug' <| __filename
list-choice = curry require './list-choice'
{format-url} = require '../utils'
require! '../api/fuzzy-filter-jobs'
require! open

cli-configure = async (opts) ->*
  debug opts, 'configure'

  (yield fuzzy-filter-jobs opts.job-name)
    .map list-choice 'no such job, did you mean one of these?\n'
    .cata do
      Just: (job-name) ->
        open format-url "/job/#job-name/configure"
      Nothing: ->
        "unable to find job: #{opts.job-name}" |> console.error

module.exports = cli-configure
