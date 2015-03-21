{coroutine: async} = require \bluebird
{fuzzy-filter-prop, format-jobs-table, die} = require '../utils'
require! '../api/list-jobs'
require! ramda: {identity, is-empty, filter, prop}
debug = require '../debug' <| __filename

REGEX = /\/([^/]+)\/?[gi]*?/
is-regex = -> REGEX.test it
str-to-regex = ->
  new RegExp (it.match REGEX .1), 'i'

prop-test = (property, re, obj) -->
  re.test prop property, obj

get-filter-by-type = (str) ->
  | str is undefined => identity
  | is-regex str     => filter prop-test \jobName, (str-to-regex str)
  | otherwise        => fuzzy-filter-prop \jobName, str

cli-list = (__: input) ->
  list-jobs!
    .then get-filter-by-type input
    .then (jobs) ->
      unless is-empty jobs
        console.log format-jobs-table jobs
      else
        console.error 'Nothing found with given parameters'
    .catch die

module.exports = cli-list
