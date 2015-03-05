require! {
  bluebird: Promise
  '../utils': { format-url }
  '../constants': { BUILD_KEYS }
  'data.maybe': Maybe
}
request = Promise.promisify require 'request'
debug = require '../debug' <| __filename

module.exports = (job-name, number) ->
  debug 'job-name=%s number=%d', job-name, number

  request {
    url: format-url "/job/#job-name/#number/api/json"
    qs: { tree: BUILD_KEYS }
    +json
  }
  .spread (res, body) ->
    debug {res.status-code, body}
    switch res.status-code
    | 200       => Maybe.Just body
    | otherwise => Maybe.Nothing!
