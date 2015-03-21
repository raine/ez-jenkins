{nock, proxyquire, async, qs, sinon} = require './test-util'
require! bluebird: Promise
require! 'data.maybe': Maybe
{called-with, called-with-exactly, not-called} = sinon.assert

cli-tail = null
sandbox = null

describe 'cli-tail' (,) ->
  before-each ->
    sandbox := sinon.sandbox.create!
    sandbox.stub console, 'error'

  after-each ->
    sandbox.restore!

  describe 'with job matches' (,) ->
    # TODO: needs a way to capture process.stdout
    it 'tails a build'

  describe 'without job matches' (,) ->
    it 'shows an error' async ->*
      cli-tail := proxyquire '../src/cli/tail',
        '../api/tail-build'   : -> Promise.resolve Maybe.Nothing!
        '../api/get-all-jobs' : -> Promise.resolve []

      yield cli-tail __: \test-job-1000
      called-with console.error, 'Unable to find job: test-job-1000'
