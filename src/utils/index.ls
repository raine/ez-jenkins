require! chalk: {red}
require! ramda: {reduce, map, tap}
merge = (xs) -> reduce (<<<), {}, xs
require-obj = (obj) ->
  {[k, require v] for k, v of obj}

die = (err) ->
  console.error red err.to-string!
  process.exit 1

module.exports = merge [
  require-obj do
    sort-abc           : './sort-abc'
    format-url         : './format-url'
    build-result-color : './build-result-color'
  require './jobs-table'
  require './fuzzy-filter'
  require './ensure-res-body'
  {die}
]
