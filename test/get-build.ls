require! bluebird: {coroutine: async}
require! <[ proxyquire nock ]>
{always} = require 'ramda'

URL = 'https://ci.jenkins.com'

get-build = proxyquire '../src/api/get-build',
  './config': { '@global': true, get: always URL }

JSON_DATA =
  building: false,
  duration: 10146,
  estimated-duration: 10116,
  number: 76,
  result: 'SUCCESS',
  timestamp: 1425590308372

describe 'get-build' (,) ->
  after-each -> nock.clean-all!

  it 'gets build as Just if found' async ->*
    nock 'https://ci.jenkins.com'
      .get '/job/test-job-1234/30/api/json?tree=building%2Ctimestamp%2CestimatedDuration%2Cduration%2Cresult%2Cnumber'
      .reply 200, JSON_DATA

    build = yield get-build \test-job-1234, 30
    ok build.is-just
    deep-eq JSON_DATA, build.get!

  it 'gets Nothing if not found' async ->*
    nock 'https://ci.jenkins.com'
      .get '/job/test-job-1234/30/api/json?tree=building%2Ctimestamp%2CestimatedDuration%2Cduration%2Cresult%2Cnumber'
      .reply 404

    build = yield get-build \test-job-1234, 30
    ok build.is-nothing
