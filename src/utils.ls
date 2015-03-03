config = require './config'
qs     = require 'qs'
{sort} = require 'ramda'

debug = require './debug' <| __filename

export format-url = (path, qs-obj) ->
  base-url = config.get \url .replace // /?$ //, ''
  query = if qs-obj then "?#{qs.stringify qs-obj}" else ''
  url = base-url + path + query
  debug { base-url, path, qs: qs-obj }
  debug url
  url

export sort-abc = sort (a, b) ->
  switch
  | a < b => -1
  | a > b => 1
  | _     => 0
