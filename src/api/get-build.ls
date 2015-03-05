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

  url = format-url "/job/#job-name/#number/api/json", {
    tree: BUILD_KEYS
  }

  request { url, +json }
    # TODO: probably not handling errors properly
    .spread (res, body) ->
      debug {res.status-code, body}
      switch res.status-code
      | 200       => Maybe.Just body
      | otherwise => Maybe.Nothing!
