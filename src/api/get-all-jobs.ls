require! bluebird: Promise
require! '../utils': {format-url, ensure-res-body}
request = Promise.promisify require 'request'
debug = require '../debug' <| __filename
require! ramda: {prop, map}

module.exports = get-all-jobs = ->
  debug 'req start'
  ensure-res-body request {
    url: format-url '/api/json'
    qs: { tree: 'jobs[name]' }
    +json
  }
  .tap -> debug 'req done'
  .get \1
  .then (map prop \name) . prop \jobs
