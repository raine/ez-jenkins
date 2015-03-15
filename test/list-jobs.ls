{nock, proxyquire, async, qs} = require './test-util'
{always} = require \ramda

list-jobs = proxyquire '../src/api/list-jobs',
  '../utils': { '@global': true, format-url: fake-format-url }

JSON_DATA = require './data/list-jobs.json'

_nock = ->
  nock JENKINS_URL
    .get '/api/json?' +
      qs tree: 'jobs[name,lastBuild[building,timestamp,estimatedDuration,duration,result,number]]'

describe 'list-jobs' (,) ->
  after-each -> nock.clean-all!

  it 'transforms data into flat list of objects' async ->*
    _nock!.reply 200, JSON_DATA
    jobs = yield list-jobs!
    
    deep-eq jobs, [
      * job-name           : \foo-1
        building           : false
        duration           : 62
        estimated-duration : 49
        number             : 133
        result             : \SUCCESS
        timestamp          : 1344503360000

      * job-name           : \foo-2
        building           : false
        duration           : 1168836
        estimated-duration : 1154187
        number             : 139
        result             : \SUCCESS
        timestamp          : 1344503365000
    ]
