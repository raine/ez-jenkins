debug = require '../debug' <| __filename
readline-sync = require 'readline-sync'
{map-indexed, join, is-nil, is-empty} = require 'ramda'

option-to-entry = (opt, i) -> "#{i+1}) #opt"
numbered-list   = (join '\n') . map-indexed option-to-entry

module.exports = list-choice = (question, list) ->
  debug {question, list}
  throw new Error 'empty list' if is-empty list
  if list.length is 1 then return list.0

  console.log question if question
  console.log numbered-list list
  num = readline-sync.prompt!
  choice = list[num - 1]

  if is-nil choice
    list-choice ...
  else 
    choice
