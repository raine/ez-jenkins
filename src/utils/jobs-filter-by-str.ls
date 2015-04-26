require! ramda: {identity, prop, filter}
require! './fuzzy-filter': {fuzzy-filter-prop}

REGEX = /\/([^/]+)\/?[gi]*?/
is-regex = -> REGEX.test it
str-to-regex = ->
  new RegExp (it.match REGEX .1), 'i'

prop-test = (property, re, obj) -->
  re.test prop property, obj

# :: String -> ([Job] -> [Job])
export jobs-filter-by-str = (str) ->
  | str is undefined => identity
  | is-regex str     => filter prop-test \jobName, (str-to-regex str)
  | otherwise        => fuzzy-filter-prop \jobName, str
