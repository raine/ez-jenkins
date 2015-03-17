{merge, for-each, map, pick-all, any, values, is-nil, slice} = require 'ramda'
require! 'cli-table': Table
require! './build-result-color'
debug = require '../debug' <| __filename
require! 'data.maybe': Maybe
require! \pretty-ms
require! chalk: {inverse}

pick-props = (props, obj) -->
  [obj[k] for k in props]

safe-props = (props, obj) -->
  picked = pick-all props, obj
  unless any is-nil, values picked
    Maybe.of picked
  else
    Maybe.Nothing!

limit-to = (n, x) -->
  if x > n then n else x

pct = (it) ->
  (+ '%') <| (limit-to 100) (it * 100).to-fixed 0

format-activity = (obj) ->
  if not obj.building
    finished    = obj.timestamp + obj.duration
    since-build = Date.now! - finished
    (+ ' ago') <| pretty-ms since-build, compact: true
  else
    duration = Date.now! - obj.timestamp
    progress = duration / obj.estimated-duration
    overdue = duration > obj.estimated-duration
    postfix = if overdue then '+ zzz...' else ''
    str = "building (#{pct progress}#postfix)"

    char-progress = (limit-to str.length) Math.round progress * str.length

    done-str = inverse slice 0, char-progress, str
    left-str = slice char-progress, str.length, str
    done-str + left-str

# TODO: truncate job name and maybe other fields as well
# TODO: what happens if first build doesn't have estimatedDuration
export format-row-obj = (obj) ->
  merge obj,
    number   : obj.number or 'N/A'
    job-name : (build-result-color obj.result) obj.job-name
    activity : safe-props <[ building timestamp duration estimatedDuration ]>, obj
      .map format-activity
      .get-or-else 'never'

export format-jobs-table = (jobs) ->
  HEAD = <[ # job activity ]>
  ROWS = <[ number jobName activity ]>

  table = new Table head: HEAD, style: { head: <[cyan bold]> }
  rows  = map ((pick-props ROWS) . format-row-obj), jobs

  for-each table~push, rows
  table.to-string!
