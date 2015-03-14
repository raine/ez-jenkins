{merge, pick, for-each, map} = require 'ramda'
require! 'cli-table': Table
require! './build-result-color'
debug = require '../debug' <| __filename

pick-props = (props, obj) -->
  [obj[k] for k in props]

# TODO: truncate job name and maybe other fields as well
export format-job-obj = (obj) ->
  merge obj,
    number   : obj.number or 'N/A'
    job-name : (build-result-color obj.result) obj.job-name

export format-jobs-table = (jobs) ->
  HEAD = <[ # job ]>
  ROWS = <[ number jobName ]>

  table = new Table head: HEAD
  rows  = map ((pick-props ROWS) . format-job-obj), jobs

  for-each table~push, rows
  table.to-string!
