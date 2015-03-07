{split, map, join, replace} = require \ramda

rtrim          = replace /\s*$/g, ''
lines          = join '\n'
unlines        = split '\n'
strip-trailing = lines . (map rtrim) . unlines

module.exports = 
  nock: require \nock
  proxyquire: require \proxyquire
  async: require \bluebird .coroutine
  qs: require \querystring .stringify
  strip-trailing: strip-trailing
