require! sinon
require! \proxyquire

{called-with, called-with-exactly} = sinon.assert
tail = sinon.spy!
setup = sinon.spy!
cli = proxyquire '../src/cli/',
  './tail': tail
  './setup': setup

describe 'tail' (,) ->
  before-each -> tail.reset!

  it 'is called with job name' ->
    cli <[ tail test-job-1234 ]>
    called-with tail, sinon.match do
      job-name: \test-job-1234

  it 'is called with --follow' ->
    cli <[ tail test-job-1234 -f ]>
    called-with tail, sinon.match do
      job-name: \test-job-1234
      follow: true

  it 'is called with --build-number' ->
    cli <[ tail test-job-1234 -b 100 ]>
    called-with tail, sinon.match do
      job-name: \test-job-1234
      build-number: 100

describe 'setup' (,) ->
  before-each -> setup.reset!

  it 'is called with job name' ->
    cli <[ setup ]>
    called-with-exactly setup
