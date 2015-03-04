require! yargs

command = yargs
  .usage 'Usage: jenkins <command> [options]'
  .command \tail,  'read build logs'
  .command \setup, 'interactively configure jenkins base url'
  .argv._.0

argv = switch command
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
      alias       : \build
    .example 'jenkins tail my-build -f'
    .example 'jenkins tail my-build -b 70'
    .help \h, 'show help'
    .alias \h, \help
    .argv
| \setup
  yargs
    .help \h, 'show help'
    .alias \h, \help
    .argv
| otherwise
  yargs.show-help!

export command
export argv
