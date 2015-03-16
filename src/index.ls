require! ramda: {has}

# force colors in both chalk and colors.js
if has \FORCE_COLOR, process.env
  process.argv.push '--color'

require 'source-map-support' .install!
require('./cli') process.argv.slice 2
