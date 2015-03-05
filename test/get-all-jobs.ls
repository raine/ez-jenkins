{nock, proxyquire, async, qs} = require './test-util'
{always} = require \ramda

get-all-jobs = proxyquire '../src/api/get-all-jobs',
  './config': { '@global': true, get: always JENKINS_URL }

JSON_DATA =
  jobs:
    * name: \foo-1
    * name: \foo-2
    * name: \foo-3
    * name: \foo-4

describe 'get-all-jobs' (,) ->
  after-each -> nock.clean-all!

  it 'gets jobs as a list' async ->*
    nock JENKINS_URL
      .get '/api/json?' + qs tree: 'jobs[name]'
      .reply 200, JSON_DATA

    jobs = yield get-all-jobs!
    deep-eq <[ foo-1 foo-2 foo-3 foo-4 ]>, jobs
