require! {
  bluebird: Promise
  '../utils': { format-url }
  '../constants': { BUILD_KEYS }
  'data.maybe': Maybe
}
request = Promise.promisify require 'request'
debug = require '../debug' <| __filename

module.exports = (job-name) ->
  debug 'job-name=%s', job-name
  tree = "lastBuild[#{BUILD_KEYS}]"
  url = format-url "/job/#job-name/api/json", { depth: 2, tree }

  request { url, +json }
    .get 1
    .get \lastBuild
    .then ->
      Maybe.from-nullable it
        .map merge {job-name}
