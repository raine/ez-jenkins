{nock, proxyquire, async, qs, sinon} = require './test-util'
require! bluebird: Promise
require! ramda: {merge}
{called-with, called-with-exactly, not-called} = sinon.assert

var cli-list
var sandbox

describe 'cli-list' (,) ->
  before-each ->
    sandbox := sinon.sandbox.create!
    sandbox.stub console, 'error'

  after-each ->
    sandbox.restore!

  describe 'without job matches' (,) ->
    before ->
      cli-list := proxyquire '../src/cli/list',
        '../api/list-jobs': -> Promise.resolve []

    it 'shows an error' async ->*
      yield cli-list input: \foo
      called-with console.error, 'Nothing found with given parameters'
