# lastCompletedBuild and lastBuild can be null in the API

require! {
  bluebird: Promise
  '../utils': {format-url, ensure-res-body}
  '../constants': {BUILD_KEYS}
  'data.maybe': Maybe
}
require! ramda: {pipe, merge, prop, map}
request = Promise.promisify require 'request'
debug = require '../debug' <| __filename

module.exports = ->
  debug 'req start'
  tree = "jobs[name,lastBuild[#{BUILD_KEYS}],lastCompletedBuild[result]]"
  ensure-res-body request {
    url: format-url "/api/json"
    qs: {tree}
    +json
  }
  .tap -> debug 'req done'
  .get \1
  .then pipe do
    prop \jobs
    map (job) -> merge job.last-build,
      {job-name: job.name, job.last-completed-build}
