proxyquire = require 'proxyquire'
nock = require 'nock'
require! bluebird: {coroutine: async}

get-all-jobs = proxyquire '../src/api/get-all-jobs',
  './config':
    '@global': true
    get: (key) ->
      'https://ci.jenkins.com' if key is 'url'

JSON_DATA =
  jobs:
    * name: \foo-1
    * name: \foo-2
    * name: \foo-3
    * name: \foo-4

nock.disable-net-connect!
nock 'https://ci.jenkins.com'
  .get '/api/json?tree=jobs%5Bname%5D'
  .reply 200, JSON_DATA

describe 'get-all-jobs' (,) ->
  it 'gets jobs as a list' async ->*
   jobs = yield get-all-jobs!
   deep-eq <[ foo-1 foo-2 foo-3 foo-4 ]>, jobs
