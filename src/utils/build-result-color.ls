require! 'data.maybe': Maybe

module.exports = ->
  switch it
  | \SUCCESS  => \green
  | \ABORTED  => \inverse
  | \FAILURE  => \red
  | otherwise => null
  |> Maybe.from-nullable
