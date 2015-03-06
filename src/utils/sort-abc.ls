{sort} = require 'ramda'

export sort-abc = sort (a, b) ->
  switch
  | a < b => -1
  | a > b => 1
  | _     => 0
