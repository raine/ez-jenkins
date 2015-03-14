{split, map, join, replace, gte} = require \ramda

rtrim          = replace /\s*$/g, ''
lines          = join '\n'
unlines        = split '\n'
strip-trailing = lines . (map rtrim) . unlines

module.exports = 
  sinon      : require \sinon
  nock       : require \nock
  proxyquire : require \proxyquire
  async      : require \bluebird .coroutine
  qs         : require \querystring .stringify
  util       : require \util

module.exports <<< {strip-trailing}
