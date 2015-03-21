require! ramda: {prop, path}
require! '../src/cli/parse'

describe 'parse' (,) ->
  it 'returns command' ->
    eq 'setup', prop \command, parse <[ setup foo bar xyz ]>

  it 'returns list of args after a command in __ as a string' ->
    eq 'foo bar xyz', path <[ argv __ ]>, parse <[ setup foo bar xyz ]>
