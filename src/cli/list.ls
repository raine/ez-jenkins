{coroutine: async} = require \bluebird
{fuzzy-filter-prop, format-jobs-table} = require '../utils'
require! '../api/list-jobs'
require! ramda: {identity, is-empty, if-else, filter, prop}
debug = require '../debug' <| __filename

fuzzy-by-name = fuzzy-filter-prop \jobName

REGEX = /\/([^/]+)\/?[gi]*?/
is-regex = -> REGEX.test it
str-to-regex = ->
  new RegExp (it.match REGEX .1), 'i'

prop-test = (property, re, obj) -->
  re.test prop property, obj

get-filter-by-type = (str) ->
  | str is undefined => identity
  | is-regex str     => filter prop-test \jobName, (str-to-regex str)
  | otherwise        => fuzzy-by-name

cli-list = ({input}) ->
  list-jobs!
    .then get-filter-by-type input
    .then (jobs) ->
      unless is-empty jobs
        console.log format-jobs-table jobs
      else
        console.error 'Nothing found with given parameters'

module.exports = cli-list
