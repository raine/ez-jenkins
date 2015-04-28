require! chalk
require! strftime
require! ramda: {join}
require! util: {format: fmt}
require! 'pretty-ms'

offset-color = ->
  | it < 0  => \green
  | it is 0 => \dim
  | it > 0  => \yellow

offset-symbol = ->
  | it < 0    => '-'
  | it > 0    => '+'
  | otherwise => ''

format-offset = (offset) ->
  color  = chalk[offset-color offset]
  symbol = offset-symbol offset
  color "(#symbol#{pretty-ms Math.abs offset})"

result-color = ->
  switch it
  | \SUCCESS => \green
  | \ABORTED => \inverse
  | \FAILURE => \red

format-result = (result) ->
  color = chalk.bold[result-color result]
  color fmt "[%s]", result

module.exports = (build) ->
  offset      = build.duration - build.estimated-duration
  finished    = build.duration + build.timestamp
  since-build = Date.now! - finished

  result = format-result build.result

  duration = [
    * chalk.bold 'Duration:'
    * pretty-ms build.duration
    * format-offset offset
  ] |> join ' '

  finished = [
    * chalk.bold 'Finished:'
    * strftime '%F %T', new Date build.timestamp
    * "(#{pretty-ms since-build, compact: true} ago)"
  ] |> join ' '

  [result, duration, finished] |> join ' '
