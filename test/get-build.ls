{nock, proxyquire, async, qs} = require './test-util'
{always} = require \ramda

get-build = proxyquire '../src/api/get-build',
  './config': { '@global': true, get: always JENKINS_URL }

JSON_DATA =
  building: false,
  duration: 10146,
  estimated-duration: 10116,
  number: 76,
  result: 'SUCCESS',
  timestamp: 1425590308372

my-nock = ->
  nock JENKINS_URL
    .get '/job/test-job-1234/30/api/json?' +
      qs tree: 'building,timestamp,estimatedDuration,duration,result,number'

describe 'get-build' (,) ->
  after-each -> nock.clean-all!

  it 'gets build as Just if found' async ->*
    my-nock!.reply 200, JSON_DATA

    build = yield get-build \test-job-1234, 30
    ok build.is-just
    deep-eq JSON_DATA, build.get!

  it 'gets Nothing if not found' async ->*
    my-nock!.reply 404

    build = yield get-build \test-job-1234, 30
    ok build.is-nothing
