require! ramda: {eq-deep}

export ensure-res-body = (req-promise) ->
  req-promise.tap ([, body]) ->
    if eq-deep body, {}
      throw new Error 'Got an empty response'
