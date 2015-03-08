yargs = require \yargs
debug = require '../debug' <| __filename

module.exports = (argv) ->
  debug argv

  command = yargs
    .usage 'Usage: jenkins <command> [options]'
    .command \tail,      'read build logs'
    .command \configure, 'open job configuration view in browser'
    .command \setup,     'interactively configure jenkins base url'
    .parse argv ._.0

  parsed-argv = switch command
  | \tail
    yargs.reset!
      .usage 'Usage: jenkins tail [options] <job-name>'
      .option \f,
        type        : \boolean
        description : "follow a job's build logs indefinitely (think tail -f)"
        alias       : \follow
      .option \b,
        type        : \number
        description : 'show output for a specific build'
        alias       : \build-number
      .example 'jenkins tail my-build -f'
      .example 'jenkins tail my-build -b 70'
      .help \h, 'show help'
      .alias \h, \help
      .parse argv
  | \configure
    yargs.reset!
      .usage 'Usage: jenkins configure <job-name>'
      .example 'jenkins configure my-build'
      .help \h, 'show help'
      .alias \h, \help
      .parse argv
  | \setup
    yargs
      .help \h, 'show help'
      .alias \h, \help
      .argv
  | otherwise
    debug 'no command matched, showing help'
    yargs.show-help!
    yargs.argv

  {command, argv: parsed-argv}
