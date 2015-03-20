yaml   = require 'js-yaml'
fs     = require 'fs'
mkdirp = require 'mkdirp'
require! path: {dirname, join}
require! ramda: {prop}

debug = require './debug' <| __filename
home = process.env.HOME
config-path = join home, \.config, \ez-jenkins, \config.yaml
debug config-path

safe-read = (path) ->
  debug 'reading path=%s', path

  if fs.exists-sync path
    yaml-str = fs.read-file-sync path, 'utf8'
    yaml.safe-load yaml-str
  else
    # ugly
    """
    config unavailable (#config-path)
    run `jenkins setup`
    """ |> console.log

    process.exit 1

read-config = do ->
  config = null
  -> config ?:= safe-read config-path

export path = config-path

export get = do ->
  config = null

  (key) ->
    debug 'get key=%s', key
    prop key, read-config!

export save = (obj) ->
  debug 'save obj=%s', JSON.stringify obj
  mkdirp.sync dirname config-path
  yaml-str = yaml.safe-dump obj
  fs.write-file-sync config-path, yaml-str
