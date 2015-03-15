require! chalk
require! ramda: {identity}

module.exports = ->
  color = switch it
  | \SUCCESS  => \green
  | \ABORTED  => \inverse
  | \FAILURE  => \red

  color and chalk[color] or identity
