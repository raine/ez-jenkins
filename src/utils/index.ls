{reduce} = require 'ramda'
merge = (xs) -> reduce (<<<), {}, xs

module.exports = merge [
  require './sort-abc'
  require './format-url'
]
