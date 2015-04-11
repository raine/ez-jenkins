{nock, proxyquire, async, qs, sinon} = require './test-util'
require! bluebird: Promise
{called-with, called-with-exactly, not-called} = sinon.assert

cli-list = null
sandbox = null
format-jobs-table = sinon.spy!

describe 'cli-list' (,) ->
  before-each ->
    sandbox := sinon.sandbox.create!
    sandbox.stub console, 'error'
    sandbox.stub console, 'log'

  after-each ->
    sandbox.restore!

  describe 'input filtering with job matches' (,) ->
    before-each -> format-jobs-table.reset!

    before ->
      cli-list := proxyquire '../src/cli/list',
        '../utils':
          format-jobs-table: format-jobs-table
        '../api/list-jobs': -> Promise.resolve [
          * job-name: \test
          * job-name: \test-123
        ]

    # TODO: test output instead of what format-jobs-table was called with?
    it 'filters by fuzzy matching if input is string' async ->*
      yield cli-list __: \tst
      called-with format-jobs-table, [
        * job-name: \test
        * job-name: \test-123
      ]

    it 'filters by regex if input is regex-like' async ->*
      yield cli-list __: '/test$/'
      called-with format-jobs-table, [
        * job-name: \test
      ]

  describe 'predicate arguments' (,) ->
    var JOBS, clock
    before-each -> format-jobs-table.reset!
    before ->
      clock := sinon.use-fake-timers Date.now!

      JOBS := [
        * job-name  : \test1
          building  : false
          timestamp : Date.now! - 1000 * 60 * 1m # recent
          result    : \SUCCESS
        * job-name  : \test2
          building  : true
          timestamp : Date.now! - 1000 * 60 * 15m
          result    : null
        * job-name  : \test3
          building  : false
          timestamp : Date.now! - 1000 * 60 * 15m
          result    : \FAILURE
      ]

      cli-list := proxyquire '../src/cli/list',
        '../utils': format-jobs-table: format-jobs-table
        '../api/list-jobs': -> Promise.resolve JOBS

    after -> clock.restore!

    it 'filters by successful' async ->*
      yield cli-list __: \test, successful: true
      called-with format-jobs-table, [JOBS.0]

    it 'filters by building' async ->*
      yield cli-list __: \test, building: true
      called-with format-jobs-table, [JOBS.1]

    it 'filters by failed' async ->*
      yield cli-list __: \test, failed: true
      called-with format-jobs-table, [JOBS.2]

    it 'filters by recent' async ->*
      yield cli-list __: \test, recent: true
      called-with format-jobs-table, [JOBS.0]

    it 'filters by failed and building together (OR)' async ->*
      yield cli-list __: \test, failed: true, building: true
      called-with format-jobs-table, [JOBS.1, JOBS.2]

  describe 'without job matches' (,) ->
    before ->
      cli-list := proxyquire '../src/cli/list',
        '../api/list-jobs': -> Promise.resolve []

    it 'shows an error' async ->*
      yield cli-list __: \foo
      called-with console.error, 'Nothing found with given parameters'
