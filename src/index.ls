require 'ramda' .installTo global
require! {
  './job-build-log'
  bluebird: Promise
}

debug = require './debug' <| __filename
async = Promise.coroutine

do async ->*
  rs = yield job-build-log 'test-job-1234'
  rs.pipe process.stdout
  rs.on 'end', ->
    console.log 'done'
    process.exit!
