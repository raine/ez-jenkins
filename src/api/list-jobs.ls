require! {
  bluebird: Promise
  '../utils': { format-url }
  '../constants': { BUILD_KEYS }
  'data.maybe': Maybe
}
{pipe, merge, prop, map} = require \ramda
request = Promise.promisify require 'request'
debug = require '../debug' <| __filename

module.exports = ->
  debug 'req start'
  tree = "jobs[lastBuild[#{BUILD_KEYS}]]"
  request {
    url: format-url "/api/json"
    qs: {tree}
    +json
  }
  .tap -> debug 'req done'
  .get \1
  .then pipe do
    prop \jobs
    map -> merge it.last-build, {job-name: it.name}
