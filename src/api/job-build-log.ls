require! {
  '../config'
  '../utils': { format-url }
  bluebird: Promise
  stream: { Readable }
  './last-build'
}

request = Promise.promisify require 'request'
debug = require '../debug' <| __filename
async = Promise.coroutine

module.exports = async (job-name) ->*
  debug 'job-build-log job-name=%s', job-name

  build = yield last-build job-name
  last-build-number = build.number
  reading = false
  start = 0
  url = format-url "/job/#job-name/#last-build-number/logText/progressiveText"

  get-next-chunk = async (start) ->*
    debug 'get-next-chunk start=%d', start
    [res, body] = yield request {
      url
      method: \post,
      form: { start }
    }

    debug pick <[ x-text-size x-more-data content-length ]> res.headers
    more-data  = res.headers.'x-more-data' is 'true'
    next-start = res.headers.'x-text-size'
    got-data   = next-start is not start
    start     := next-start

    if got-data
      stop = rs.push body, 'utf8'

    unless more-data 
      debug 'no more data'
      rs.push null
    else if stop is not false
      set-timeout (-> get-next-chunk next-start), 1000

  rs = new Readable!
  rs._read = !->
    debug '_read'
    unless reading
      reading := true
      get-next-chunk start

  return rs
