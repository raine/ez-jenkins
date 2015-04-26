yargs = require \yargs
debug = require '../debug' <| __filename
require! ramda: {join, merge}

module.exports = (argv) ->
  debug argv

  command = yargs.reset!
    .usage 'Usage: jenkins <command> [options]'
    .command \list,      'list jobs'
    .command \tail,      'read build logs'
    .command \configure, 'open job configuration view in browser'
    .command \setup,     'interactively configure jenkins base url'
    .demand 1, null
    .parse argv ._.0

  parsed-argv = switch command
  | \list
    yargs.reset!
      .usage 'Usage: jenkins list [options] [<job-pattern>]'
      .demand 1, null
      .option \b,
        type        : \boolean
        description : "list building jobs"
        alias       : \building
        default     : void
      .option \s,
        type        : \boolean
        description : "list successful jobs"
        alias       : \successful
        default     : void
      .option \f,
        type        : \boolean
        description : "list failed jobs"
        alias       : \failed
        default     : void
      .option \r,
        type        : \boolean
        description : "list recent jobs (<10min)"
        alias       : \recent
        default     : void
      .example 'jenkins list'
      .example 'jenkins list my-build'
      .example 'jenkins list --building --failed'
      .epilogue do
        """
        <job-pattern> can be a regex or fuzzily matching string

        multiple predicates are combined in OR fashion
        """
      .help \h, 'show help'
      .alias \h, \help
      .parse argv
  | \tail
    yargs.reset!
      .usage 'Usage: jenkins tail [options] <job-pattern>'
      .demand 2, null
      .option \f,
        type        : \boolean
        description : "follow a job's build logs indefinitely (think tail -f)"
        alias       : \follow
      .option \b,
        type        : \number
        description : 'show output for a specific build'
        alias       : \build-number
      .option \m,
        type        : \boolean
        description : 'tail and follow multiple jobs'
        alias       : \multi
      .example 'jenkins tail my-build -f'
      .example 'jenkins tail my-build -b 70'
      .epilogue do
        """
        <job-pattern> can be a regex or fuzzily matching string

        --multi works so that when the given pattern matches multiple jobs,
          ez-jenkins will always tail one of the jobs that has a build running
        """
      .help \h, 'show help'
      .alias \h, \help
      .parse argv
  | \configure
    yargs.reset!
      .usage 'Usage: jenkins configure <job-name>'
      .demand 2, null
      .example 'jenkins configure my-build'
      .help \h, 'show help'
      .alias \h, \help
      .parse argv
  | \setup
    yargs.reset!
      .help \h, 'show help'
      .alias \h, \help
      .parse argv
  | otherwise
    debug 'no command matched, showing help'
    yargs.show-help!
    process.exit 1

  __ = parsed-argv._.slice 1 |> join ' '

  command : command
  argv    : merge parsed-argv, {__}
