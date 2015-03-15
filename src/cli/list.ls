{coroutine: async} = require \bluebird
{fuzzy-filter-prop, format-jobs-table} = require '../utils'
require! '../api/list-jobs'
require! ramda: {identity}
debug = require '../debug' <| __filename

fuzzy-by-name = fuzzy-filter-prop \jobName

cli-list = ({input}) ->
  list-jobs!
    .then input && fuzzy-by-name input || identity
    .then format-jobs-table
    .then console.log

module.exports = cli-list
