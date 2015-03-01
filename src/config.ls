# TODO: check that URL is available

require! { path, fs }
debug = require './debug' <| __filename

home = process.env.HOME
config-path = path.join home, \.config, \jenkins, \config.json
debug config-path
default-config = {}

safe-read = (path) ->
  if fs.exists-sync path
    require path
  else
    console.log "ERROR: config file unavailable (#config-path)"
    process.exit 1

config = merge default-config, safe-read config-path
debug config

module.exports = config
