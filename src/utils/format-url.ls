config = require '../config'
debug  = require '../debug' <| __filename

module.exports = (path) ->
  base-url = config.get \url .replace // /?$ //, ''
  url = base-url + path
  debug url
  url
