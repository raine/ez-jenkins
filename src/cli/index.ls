require! {
  './tail'
  yargs
}

command = yargs
  .usage 'Usage: jenkins <command> [options]'
  .command 'tail', 'read build logs'
  .argv._.0

switch command
| \tail
  yargs.reset!
    .usage "Usage: jenkins tail [options] <job-name>"
    .option \f,
      type        : \boolean
      description : "follow a job's build logs"
      alias       : \follow
    .option \b,
      type        : \number
      description : "tail a specific build"
      alias       : \build
    .help \help, 'show help'
    .alias \h, \help
    .argv |> tail
| otherwise
  yargs.show-help!
