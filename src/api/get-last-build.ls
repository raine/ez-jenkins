require! {
  bluebird: Promise
  '../utils': { format-url }
  '../constants': { BUILD_KEYS }
  'data.maybe': Maybe
}
{merge} = require \ramda
request = Promise.promisify require 'request'
debug = require '../debug' <| __filename

module.exports = (job-name) ->
  debug 'job-name=%s', job-name
  tree = "lastBuild[#{BUILD_KEYS}]"
  request {
    url: format-url "/job/#job-name/api/json"
    qs: { depth: 2, tree }
    +json
  }
  .get 1
  .get \lastBuild
  .then ->
    Maybe.from-nullable it
      .map merge {job-name}
