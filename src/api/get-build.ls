require! {
  bluebird: Promise
  '../utils': { format-url }
  '../constants': { BUILD_KEYS }
}
request = Promise.promisify require 'request'
debug = require '../debug' <| __filename

module.exports = (job-name, number) ->
  debug 'job-name=%s number=%d', job-name, number

  url = format-url "/job/#job-name/#number/api/json", {
    tree: BUILD_KEYS
  }

  request { url, +json }
