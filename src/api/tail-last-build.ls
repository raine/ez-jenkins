require! {
  '../constants': { POLL_DELAY_MS }
  '../config'
  '../utils': { format-url }
  './get-last-build'
  './get-build'
  bluebird: Promise
  stream: { Readable }
  through2: through
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
      set-timeout (-> get-next-chunk next-start), POLL_DELAY_MS

  log-stream = new Readable!
    .._read = !->
      debug '_read reading=%s', reading
      unless reading
        reading := true
        get-next-chunk start

  log-stream

wait-for-build = async (job-name, build-number) ->*
  debug 'wait-for-build job-name=%s build-number=%d', job-name, build-number
  [res, body] = yield get-build job-name, build-number

  switch res.status-code
  | 404
    yield Promise.delay POLL_DELAY_MS
    return yield wait-for-build job-name, build-number
  | 200
    return yield Promise.resolve body

recur-tail = (output, follow, job-name, build-number) -->
  recur = recur-tail output, follow, job-name

  debug 'recur-tail build-number=%d', build-number
  stream = tail-build job-name, build-number
    ..pipe output, end: follow is false

  if follow
    stream.on \end, async ->*
      debug 'stream ended build-number=%d', build-number
      next-build = yield wait-for-build job-name, build-number + 1
      recur next-build.number

module.exports = async (job-name, follow) ->*
  debug 'job-name=%s follow=%s', job-name, follow
  output = through.obj!
    ..set-max-listeners 0
  last-build = yield get-last-build job-name
  recur-tail output, follow, job-name, last-build.number

  return output
