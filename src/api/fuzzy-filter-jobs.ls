{is-empty, curry-n, map, prop, take} = require 'ramda'
{coroutine: async} = require \bluebird
Maybe = require 'data.maybe'
require! './get-all-jobs'
debug = require '../debug' <| __filename

fuzzy = curry-n 2, (require \fuzzy .filter)
fuzzy-filter-jobs = async (pattern) ->*
  debug 'fuzzy-filter-jobs pattern=%s', pattern
  jobs = yield get-all-jobs!
    .then fuzzy pattern
    .then map prop \string

  return if is-empty jobs
    Maybe.Nothing!
  else
    Maybe.of jobs .map take 10

module.exports = fuzzy-filter-jobs
