require! bluebird: Promise
require! '../utils': { format-url }
request = Promise.promisify require 'request'
debug = require '../debug' <| __filename
require! ramda: {prop, map}

module.exports = get-all-jobs = ->
  debug 'start'
  request {
    url: format-url '/api/json'
    qs: { tree: 'jobs[name]' }
    +json
  }
  .get \1
  .then (map prop \name) . prop \jobs
  .tap debug
