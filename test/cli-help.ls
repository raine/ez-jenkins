{async, strip-trailing} = require './test-util'
exec = require \child_process .exec
require! util

describe 'bin/jenkins' (,) ->
  it 'displays help' (done) ->
    # TODO: slow as hell, figure out a way to capture process.stderr without
    # spawning a new process
    (,, stderr) <- exec 'DEBUG=0 ./node_modules/.bin/lsc ./src/index.ls'
    stderr := strip-trailing stderr

    help =
      """
      Usage: jenkins <command> [options]

      Commands:
        list         list jobs
        tail         read build logs
        configure    open job configuration view in browser
        setup        interactively configure jenkins base url\n\n
      """

    eq help, stderr
    done!
