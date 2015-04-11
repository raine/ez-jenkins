{nock, proxyquire, async, qs, sinon, Maybe, Promise} = require './test-util'
{called, called-with, called-with-exactly, not-called} = sinon.assert
require! ramda: {for-each}

require! \readline-sync

save = sinon.spy!
die  = sinon.spy!

var cli-setup, check-base-url-stub, prompt-stub, sandbox

describe 'cli-setup' (,) ->
  before ->
    prompt-stub         := sinon.stub readline-sync, \prompt
    check-base-url-stub := sinon.stub!

    # makes proxyquire not load modules' original code. important because
    # every time proxyquire is called without noCallThru it will load all
    # requires of the module which doesn't make sense if the module is
    # completely stubbed. '../api/check-base-url' for example promisifies
    # request every time which is a very slow operation
    proxyquire.no-call-thru!

    cli-setup := proxyquire '../src/cli/setup',
      'readline-sync': {prompt: prompt-stub}
      '../api/check-base-url': check-base-url-stub
      '../config': {save},
      '../utils': {die}

  before-each ->
    sandbox := sinon.sandbox.create!
    sandbox.stub process.stdout, 'write'
    sandbox.stub console, 'log'
    sandbox.stub console, 'error'

  after ->
    prompt-stub.restore!
    proxyquire.call-thru!

  after-each ->
    [ prompt-stub, check-base-url-stub, save ].for-each -> it.reset!
    sandbox.restore!

  describe 'general' (,) ->
    before ->
      prompt-stub.returns 'http://www.google.com'
      check-base-url-stub.returns Promise.resolve Maybe.Just!

    it 'prompts for base url' async ->*
      yield cli-setup!
      called prompt-stub

    it 'checks the given URL for working jenkins API' async ->*
      yield cli-setup!
      called-with check-base-url-stub, 'http://www.google.com'

  describe 'with working URL' (,) ->
    before ->
      prompt-stub.returns 'http://www.google.com'
      check-base-url-stub.returns Promise.resolve Maybe.Just!

    it 'prints OK'
    it 'saves URL to config' async ->*
      yield cli-setup!
      called-with save, url: 'http://www.google.com'
      
  describe 'with bad URL' (,) ->
    before ->
      prompt-stub.returns \whatever
      check-base-url-stub.returns Promise.resolve Maybe.Nothing!

    it 'prints an error' async ->*
      yield cli-setup!
      called die
