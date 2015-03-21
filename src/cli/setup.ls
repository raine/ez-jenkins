require! bluebird: {coroutine: async}: Promise
require! 'readline-sync'
require! '../api/check-base-url'
require! '../config'
require! chalk: {bold}
require! '../utils': {die}
require! ramda: {bind}

write = bind process.stdout.write, process.stdout

module.exports = async ->*
  """
  Enter jenkins base url (abort with ^C)
  Base url is the url of jenkins' main view
  """ |> console.log

  base-url = readline-sync.prompt!

  write 'Checking URL..'
  interval = set-interval (-> write '.'), 200

  check-base-url base-url
    .tap -> clear-interval interval
    .then ->
      it.cata do
        Just: ->
          write bold.green ' OK!\n'
          config.save base-url

          """
          Configuration written to #{config.path}
          Ready to go!
          """ |> console.log
        Nothing: ->
          write '\n'
          die "Error: Could not find jenkins API in the given URL"

    .catch ->
      write '\n'
      die it
