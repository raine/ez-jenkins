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
    .help \help, 'show help'
    .alias \h, \help
    .argv
| \setup
  yargs.argv
| otherwise
  yargs.show-help!

switch command
| \tail
  return yargs.show-help! unless argv._.1
  (require './tail') argv._.1, argv.build, argv.follow
| \setup
  (require './setup')!
