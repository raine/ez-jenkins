{proxyquire, sinon} = require './test-util'
{called, called-with, called-with-exactly} = sinon.assert

list      = sinon.spy!
tail      = sinon.spy!
setup     = sinon.spy!
configure = sinon.spy!

cli = proxyquire '../src/cli/',
  './tail'      : tail
  './setup'     : setup
  './configure' : configure
  './list'      : list

describe 'list' (,) ->
  before-each -> list.reset!

  it 'is called with input' ->
    cli <[ list foo ]>
    called-with list, sinon.match do
      __: \foo

describe 'tail' (,) ->
  before-each -> tail.reset!

  it 'is called with job name' ->
    cli <[ tail test-job-1234 ]>
    called-with tail, sinon.match do
      __: \test-job-1234

  it 'is called with --follow' ->
    cli <[ tail test-job-1234 -f ]>
    called-with tail, sinon.match do
      __: \test-job-1234
      follow: true

  it 'is called with --build-number' ->
    cli <[ tail test-job-1234 -b 100 ]>
    called-with tail, sinon.match do
      __: \test-job-1234
      build-number: 100

describe 'setup' (,) ->
  before-each -> setup.reset!

  it 'is called' ->
    cli <[ setup ]>
    called setup

describe 'configure' (,) ->
  before-each -> configure.reset!

  it 'is called with job name' ->
    cli <[ configure test-job-1234 ]>
    called-with-exactly configure, sinon.match do
      __: \test-job-1234
