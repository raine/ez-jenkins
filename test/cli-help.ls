{async, strip-trailing, unlines} = require './test-util'
require! child_process: {exec}
require! ramda: {head}

first-line = head . unlines

describe 'bin/jenkins' (,) ->
  it 'displays help' (done) ->
    (,, stderr) <- exec './node_modules/.bin/lsc ./src/index.ls'
    stderr := strip-trailing stderr

    help =
      """
      Usage: jenkins <command> [options]

      Commands:
        tail         read build logs
        configure    open job configuration view in browser
        setup        interactively configure jenkins base url\n\n
      """

    eq help, stderr
    done!

describe 'tail' (,) ->
  it 'shows help if not called with at least one argument' (done) ->
    (,, stderr) <- exec './node_modules/.bin/lsc ./src/index.ls tail'
    eq 'Usage: jenkins tail [options] <job-name>', first-line stderr
    done!
