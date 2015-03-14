{curry-n, map, prop, take} = require 'ramda'

fuzzy = curry-n 2, (require \fuzzy .filter)
module.exports = (property, pattern, list) -->
  # if more than n, could get only the ones with top score
  fuzzy pattern, list, extract: prop property
  |> map prop \original
  |> take 10
