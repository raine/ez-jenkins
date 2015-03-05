config = require './config'
{sort} = require 'ramda'

debug = require './debug' <| __filename

export format-url = (path) ->
  base-url = config.get \url .replace // /?$ //, ''
  url = base-url + path
  debug url
  url

export sort-abc = sort (a, b) ->
  switch
  | a < b => -1
  | a > b => 1
  | _     => 0
