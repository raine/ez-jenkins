require! {
  bluebird: Promise
  '../utils': { format-url }
  '../constants'
}
request = Promise.promisify require 'request'
debug = require '../debug' <| 'last-build'

module.exports = (job-name) ->
  debug 'last-build job-name=%s', job-name

  tree = "lastBuild[#{constants.BUILD_KEYS}]"
  url = format-url "/job/#job-name/api/json", { depth: 2, tree }
  request { url, +json }
    .get 1
    .get \lastBuild
