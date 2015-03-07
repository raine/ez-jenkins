require! chalk
require! ramda: {reduce}
merge = (xs) -> reduce (<<<), {}, xs

die = (err) ->
  console.error chalk.red err.to-string!
  process.exit 1

module.exports = merge [
  require './sort-abc'
  require './format-url'
  require './format-url'
  {die}
]
