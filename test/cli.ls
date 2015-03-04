require! sinon
require! \proxyquire

{called-with} = sinon.assert
spy = sinon.spy!
cli = proxyquire '../src/cli/',
  './tail': spy

describe 'tail' (,) ->
  before-each -> spy.reset!

  it 'is called with job name' ->
    cli <[ tail test-job-1234 ]>
    called-with spy, sinon.match do
      job-name: \test-job-1234

  it 'is called with --follow' ->
    cli <[ tail test-job-1234 -f ]>
    called-with spy, sinon.match do
      job-name: \test-job-1234
      follow: true

  it 'is called with --build-number' ->
    cli <[ tail test-job-1234 -b 100 ]>
    called-with spy, sinon.match do
      job-name: \test-job-1234
      build-number: 100
