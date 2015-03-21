require! 'data.maybe': Maybe
require! bluebird: Promise
require! ramda: {prop}
request = Promise.promisify require 'request'
debug = require '../debug' <| __filename

module.exports = check-base-url = (base-url) ->
  url = "#base-url/api/json".replace // /?$ //, ''
  debug url
  request {
    url
    qs: { tree: \primaryView }
    +json
  }
  .tap -> debug 'req done'
  .get \1
  .then (Maybe.from-nullable . prop \primaryView)
