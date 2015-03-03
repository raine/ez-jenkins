require! chalk
chalk.enabled = false

global <<< require 'ramda'
global.assert = require \chai .assert
global.deep-eq = (a, b) --> a `assert.deepEqual` b
global.eq = assert.strict-equal
global.ok = assert.ok
