{coroutine: async} = require \bluebird
{fuzzy-filter-prop, format-jobs-table} = require '../utils'
require! '../api/list-jobs'
debug = require '../debug' <| __filename

fuzzy-by-name = fuzzy-filter-prop \jobName

cli-list = async (opts) ->*
  jobs = fuzzy-by-name opts.input, yield list-jobs!
  console.log format-jobs-table jobs

module.exports = cli-list
