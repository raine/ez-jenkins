{__, prop, merge, for-each, map, pick-all, any, values, is-nil, slice, identity} = require 'ramda'
require! 'cli-table': Table
require! './build-result-color'
debug = require '../debug' <| __filename
require! 'data.maybe': Maybe
require! \pretty-ms
require! chalk

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
  (+ '%') <| (limit-to 100pct) (it * 100).to-fixed 0

format-activity = (obj) ->
  if not obj.building
    finished    = obj.timestamp + obj.duration
    since-build = Date.now! - finished
    str = (+ ' ago') <| pretty-ms since-build, compact: true

    color-fn = switch
    | since-build < 1000 * 60 * 10min   => chalk.bold
    | since-build > 1000 * 60 * 60 * 1h => chalk.dim
    | otherwise                         => identity

    color-fn str
  else
    duration = Date.now! - obj.timestamp
    progress = duration / obj.estimated-duration
    overdue  = duration > obj.estimated-duration
    postfix  = if overdue then '+' else ''
    str      = "building (#{pct progress}#postfix)"

    char-progress = (limit-to str.length) Math.round progress * str.length

    done-str = chalk.inverse slice 0, char-progress, str
    left-str = slice char-progress, str.length, str
    done-str + left-str

# obj.result can be null
format-name = (obj) ->
  color-str = if obj.building and obj.last-completed-build
    obj.last-completed-build.result
  else
    obj.result

  build-result-color color-str
    .map prop __, chalk
    .map (c) -> if obj.building then c.bold else c
    .ap Maybe.of obj.job-name
    .get!

# TODO: truncate job name and maybe other fields as well
# TODO: what happens if first build doesn't have estimatedDuration
export format-row-obj = (obj) ->
  merge obj,
    number   : obj.number or 'N/A'
    job-name : format-name obj
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
