{nock, proxyquire, async, qs, sinon} = require './test-util'
require! bluebird: Promise
require! 'data.maybe': Maybe
{merge} = require 'ramda'
{called-with, called-with-exactly, not-called} = sinon.assert

open = sinon.spy!
var cli-configure
var sandbox

proxyquire-defaults =
  'open': open
  '../utils': { '@global': true, format-url: fake-format-url }

describe 'cli-configure' (,) ->
  before-each ->
    sandbox := sinon.sandbox.create!
    sandbox.stub console, 'error'
    open.reset!

  after-each ->
    sandbox.restore!

  describe 'with job matches' (,) ->
    before ->
      cli-configure := proxyquire '../src/cli/configure', merge proxyquire-defaults,
        '../api/fuzzy-filter-jobs': -> Promise.resolve Maybe.of <[ test-job-1234 ]>

    it 'opens url in browser' async ->*
      yield cli-configure <[ whatever ]>
      called-with-exactly open, JENKINS_URL + '/job/test-job-1234/configure'

  describe 'without job matches' (,) ->
    before ->
      cli-configure := proxyquire '../src/cli/configure', merge proxyquire-defaults,
        '../api/fuzzy-filter-jobs': -> Promise.resolve Maybe.Nothing!

    it "doesn't open browser" async ->*
      yield cli-configure job-name: \test-job-1234
      not-called open

    it 'shows an error without job matches' async ->*
      yield cli-configure job-name: \test-job-1000
      called-with console.error, 'Unable to find job: test-job-1000'
