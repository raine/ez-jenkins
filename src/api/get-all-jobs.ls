require! bluebird: Promise
require! '../utils': { format-url }
request = Promise.promisify require 'request'
debug = require '../debug' <| __filename
require! ramda: {prop, map}

module.exports = get-all-jobs = ->
  debug 'start'
  url = format-url '/api/json', tree: 'jobs[name]'
  request { url, +json }
    .get \1
    .then (map prop \name) . prop \jobs
