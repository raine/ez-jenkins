config = require '../config'
debug  = require '../debug' <| __filename

export format-url = (path) ->
  base-url = config.get \url .replace // /?$ //, ''
  url = base-url + path
  debug url
  url
