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

tail-build = (job-name, build-number) ->
  debug 'tail-build job-name=%s build-number=%d', job-name, build-number
  reading = false
  start = 0
  url = format-url "/job/#job-name/#build-number/logText/progressiveText"

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
      stop = not log-stream.push body, 'utf8'
      debug 'stop=%s', stop

    unless more-data
      debug 'no more data'
      return log-stream.push null

    if stop is not true
      set-timeout (-> get-next-chunk next-start), 1000

  log-stream = new Readable!
  log-stream._read = !->
    debug '_read reading=%s', reading
    unless reading
      reading := true
      get-next-chunk start

  log-stream

module.exports = async (job-name) ->*
  debug 'tail-last-build job-name=%s', job-name

  build = yield last-build job-name
  stream = tail-build job-name, build.number
  stream.on \end ->
    console.log 'completed'

  return merge build, { stream }
