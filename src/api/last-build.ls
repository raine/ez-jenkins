require! {
  bluebird: Promise
  '../utils': { format-url }
}
request = Promise.promisify require 'request'
debug = require '../debug' <| 'last-build'

module.exports = (job-name) ->
  debug 'last-build job-name=%s', job-name

  tree = 'lastBuild[building,timestamp,estimatedDuration,duration,result,number]'
  url = format-url "/job/#job-name/api/json", { depth: 2, tree }
  request { url, +json }
    .get 1
    .get \lastBuild
