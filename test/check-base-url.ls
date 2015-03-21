{nock, async, qs} = require './test-util'
{always} = require \ramda

require! '../src/api/check-base-url'

JSON_DATA =
  primary-view: 'foo'

describe 'check-base-url' (,) ->
  after-each -> nock.clean-all!

  req = ->
    nock 'http://ci.example.com'
      .get '/api/json?' + qs tree: 'primaryView'

  it 'returns Just if it finds primaryView' async ->*
    req!.reply 200, JSON_DATA
    res = yield check-base-url 'http://ci.example.com'
    ok res.is-just

  it "returns Nothing if doesn't find primaryView" async ->*
    req!.reply 200, {}
    res = yield check-base-url 'http://ci.example.com'
    ok res.is-nothing

  it "returns Nothing if it doesn't find JSON" async ->*
    req!.reply 500, 'notjson'
    res = yield check-base-url 'http://ci.example.com'
    ok res.is-nothing
