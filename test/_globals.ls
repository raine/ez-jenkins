global.assert = require \chai .assert
global.deep-eq = (a, b) --> a `assert.deepEqual` b
global.eq = assert.strict-equal
global.ok = assert.ok

global.JENKINS_URL = 'https://ci.jenkins.com'
global.fake-format-url = (path) ->
  JENKINS_URL + path
