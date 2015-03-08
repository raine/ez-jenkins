{async, strip-trailing} = require './test-util'
exec = require \child_process .exec
require! util

describe 'bin/jenkins' (,) ->
  it 'displays help' async ->*
    (,, stderr) <- exec './bin/jenkins'
    stderr := strip-trailing stderr

    help =
      """
      Usage: jenkins <command> [options]

      Commands:
        tail     read build logs
        setup    interactively configure jenkins base url\n\n
      """

    eq help, stderr
