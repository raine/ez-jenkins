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

  describe 'with job matches' (,) ->
    before-each -> format-jobs-table.reset!

    before ->
      sinon
      cli-list := proxyquire '../src/cli/list',
        '../utils':
          format-jobs-table: format-jobs-table

        '../api/list-jobs': -> Promise.resolve [
          * job-name: \test
          * job-name: \test-123
        ]

    # TODO: test output instead of what format-jobs-table was called with?
    it 'filters by fuzzy matching if input is string' async ->*
      yield cli-list input: \tst
      called-with format-jobs-table, [
        * job-name: \test
        * job-name: \test-123
      ]

    it 'filters by regex if input is regex-like' async ->*
      yield cli-list input: '/test$/'
      called-with format-jobs-table, [
        * job-name: \test
      ]

  describe 'without job matches' (,) ->
    before ->
      cli-list := proxyquire '../src/cli/list',
        '../api/list-jobs': -> Promise.resolve []

    it 'shows an error' async ->*
      yield cli-list input: \foo
      called-with console.error, 'Nothing found with given parameters'
