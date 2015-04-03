{curry-n, map, prop, take, is-empty} = require 'ramda'
Maybe = require 'data.maybe'

fuzzy = curry-n 2, (require \fuzzy .filter)
export fuzzy-filter-prop = (property, pattern, list) -->
  # if more than n, could get only the ones with top score
  fuzzy pattern, list, extract: prop property
  |> map prop \original

export fuzzy-filter = (pattern, list) -->
  filtered = map (prop \string), fuzzy pattern, list

  if is-empty filtered
    Maybe.Nothing!
  else
    Maybe.of filtered .map take 10
