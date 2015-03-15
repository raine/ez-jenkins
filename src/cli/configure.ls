{curry} = require 'ramda'
{coroutine: async} = require \bluebird
debug = require '../debug' <| __filename
list-choice = curry require './list-choice'
get-all-jobs = require '../api/get-all-jobs'
{format-url} = require '../utils'
{fuzzy-filter, format-jobs-table} = require '../utils'
require! open

cli-configure = async (opts) ->*
  debug opts, 'configure'

  (fuzzy-filter opts.job-name, yield get-all-jobs!)
    .map list-choice 'no such job, did you mean one of these?\n'
    .cata do
      Just: (job-name) ->
        open format-url "/job/#job-name/configure"
      Nothing: ->
        "Unable to find job: #{opts.job-name}" |> console.error

module.exports = cli-configure
