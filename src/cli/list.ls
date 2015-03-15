{coroutine: async} = require \bluebird
{fuzzy-filter-prop, format-jobs-table} = require '../utils'
require! '../api/list-jobs'
require! ramda: {identity, is-empty}
debug = require '../debug' <| __filename

fuzzy-by-name = fuzzy-filter-prop \jobName

cli-list = ({input}) ->
  list-jobs!
    .then input && fuzzy-by-name input || identity
    .then (jobs) ->
      unless is-empty jobs
        console.log format-jobs-table jobs
      else
        console.error 'Nothing found with given parameters'

module.exports = cli-list
