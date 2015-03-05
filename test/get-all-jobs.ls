require! proxyquire
require! nock
require! bluebird: {coroutine: async}
require! ramda: {always}

get-all-jobs = proxyquire '../src/api/get-all-jobs',
  './config':
    '@global': true
    get: always 'https://ci.jenkins.com'

JSON_DATA =
  jobs:
    * name: \foo-1
    * name: \foo-2
    * name: \foo-3
    * name: \foo-4

describe 'get-all-jobs' (,) ->
  after-each -> nock.clean-all!

  it 'gets jobs as a list' async ->*
    nock 'https://ci.jenkins.com'
      .get '/api/json?tree=jobs%5Bname%5D'
      .reply 200, JSON_DATA

    jobs = yield get-all-jobs!
    deep-eq <[ foo-1 foo-2 foo-3 foo-4 ]>, jobs
