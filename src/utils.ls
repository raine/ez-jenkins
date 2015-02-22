require! {
  './config'
  qs
}

export format-url = (path, qs-obj) ->
  base-url = config.jenkins-URL
  query = if qs-obj then "?#{qs.stringify qs-obj}" else ''
  base-url + path + query
