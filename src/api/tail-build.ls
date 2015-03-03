require! {
  '../constants': { POLL_DELAY_MS }
  '../utils': { format-url }
  './get-last-build'
  './get-build'
  bluebird: Promise
  stream: { Readable }
  through2: through
  split
}


require! ramda: {merge, pick}
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
      # remove last newline if build is done, workaround for
      # https://github.com/dominictarr/split/issues/13
      body := body - /\r\n$/ unless more-data
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

  log-stream .pipe split!

wait-for-build = async (job-name, build-number) ->*
  debug 'wait-for-build job-name=%s build-number=%d', job-name, build-number
  build = yield get-build job-name, build-number

  switch
  | build.is-just =>
    return yield Promise.resolve merge {job-name}, build.get!
  | otherwise
    yield Promise.delay POLL_DELAY_MS
    return yield wait-for-build job-name, build-number

recur-tail = (output, follow, build) !-->
  debug 'recur-tail job-name=%s build-number=%d', build.job-name, build.number
  recur = recur-tail output, follow

  stream = tail-build build.job-name, build.number
    .once \data !->
      output.write merge {build}, event: \GOT_BUILD

    .on \end, async ->*
      debug 'stream ended build-number=%d', build.number

      if follow
        output.write event: \WAITING_FOR_BUILD
        next-build = yield wait-for-build build.job-name, build.number + 1
        recur next-build

    .pipe output, end: false

export tail = async (job-name, build-number, follow) ->*
  debug 'tail job-name=%s build-number=%d follow=%s', job-name, build-number, follow

  build = yield switch
  | build-number?
    get-build job-name, build-number
  | otherwise
    get-last-build job-name

  return build
    .map merge {job-name}
    .map (build) ->
      output = through.obj!
      recur-tail output, (not build-number and follow), build
      output
