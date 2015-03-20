yaml   = require 'js-yaml'
fs     = require 'fs'
path   = require 'path'
mkdirp = require 'mkdirp'

debug = require './debug' <| __filename
home = process.env.HOME
export config-path = path.join home, \.config, \ez-jenkins, \config.yaml
debug config-path

safe-read = (path) ->
  debug 'reading path=%s', path

  if fs.exists-sync path
    yaml-str = fs.read-file-sync path, 'utf8'
    yaml.safe-load yaml-str
  else
    """
    config unavailable (#config-path)
    run `jenkins setup`
    """ |> console.log

    process.exit 1

config = null
export get = (key) ->
  debug 'get key=%s', key
  config ?:= safe-read config-path
  config[key]

export save = (obj) ->
  debug 'save obj=%s', JSON.stringify obj
  mkdirp.sync path.dirname config-path
  yaml-str = yaml.safe-dump obj
  fs.write-file-sync config-path, yaml-str
