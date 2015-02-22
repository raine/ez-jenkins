require! { path, fs }

debug = require './debug' <| __filename
home = process.env.HOME
config-path = path.join home, \.config, \jenkins, \config.json
debug config-path
default-config = {}

safe-read = ->
  switch fs.exists-sync it
  | true      => require it
  | otherwise => {}

config = merge default-config, safe-read config-path
debug config

module.exports = config
