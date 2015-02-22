require! debug
require! path: { basename, extname }

without-ext = ->
  basename it, extname it

format-name = without-ext . basename

module.exports = (filename) ->
  debug format-name filename
