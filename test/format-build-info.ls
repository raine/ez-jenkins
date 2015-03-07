{strip-trailing, str-contains, sinon} = require './test-util'
require! '../src/cli/format-build-info'
require! \pretty-ms

BUILD_DATA = 
  building: false,
  duration: 13903,
  estimatedDuration: 11364,
  number: 82,
  result: 'SUCCESS',
  timestamp: 1425683052872

var clock
describe 'format-build-info' (,) ->
  before ->
    clock := sinon.use-fake-timers Date.now!

  after ->
    clock.restore!

  it 'formats build info' ->
    finished = BUILD_DATA.duration + BUILD_DATA.timestamp
    since-build = Date.now! - finished
    since-str = pretty-ms since-build, compact: true

    eq "\u001b[1m\u001b[32m[SUCCESS]\u001b[39m\u001b[22m " +
       "\u001b[1mDuration:\u001b[22m 13.9s \u001b[31m(+2.5s)\u001b[39m " +
       "\u001b[1mFinished:\u001b[22m 2015-03-07 01:04:12 (#since-str ago)",
       format-build-info BUILD_DATA
