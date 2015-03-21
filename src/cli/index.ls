require! './parse'
require-cmd = -> require "./#it"

module.exports = (raw-argv) ->
  {command, argv} = parse raw-argv
  require-cmd command <| argv
