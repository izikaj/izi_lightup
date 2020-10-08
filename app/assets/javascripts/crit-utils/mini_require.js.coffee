((window, document) -> (
  window.__required ||= {}

  _onload = (id) ->
    return if typeof(__required[id]) is 'undefined' || __required[id].loaded

    __required[id].loaded = true
    callbacks = __required[id].callbacks
    return unless Array.isArray(callbacks)

    while callbacks.length > 0
      callback = callbacks.shift()
      callback.call(window) if typeof(callback) is 'function'

  _buildSubscriptions = (id, node) ->
    data = __required[id]
    return if data.loaded
    data.callbacks ||= []
    data.started = true

    callback = node.onload
    node.onload = -> _onload(id)
    node.addEventListener('load', -> _onload(id)) if typeof(node.addEventListener) is 'function'
    node.attachEvent('load', -> _onload(id)) if typeof(node.attachEvent) is 'function'

    data.callbacks.push(callback) if typeof(callback) is 'function'

  _subscribe = (id, callback) ->
    return if typeof(__required[id]) is 'undefined'

    data = __required[id]
    return setTimeout(callback, 0) if data.loaded

    data.callbacks.push(callback) if typeof(callback) is 'function'

  window.miniRequire ||= (key, source_url, callback = undefined) ->
    id = "source_#{key.replace(/[^a-z0-9_\-]+/ig, '_')}"

    # subscribe only if already attached & started
    return _subscribe(id, callback) if __required[id]?.started?

    __required[id] = {loaded: false, callbacks: []}
    # subscribe only if no source
    return _subscribe(id, callback) unless source_url?

    # attach script
    src = document.createElement('script')
    src.id = id
    src.async = true
    src.defer = true
    src.src = source_url
    _buildSubscriptions(id, src)
    _subscribe(id, callback)

    document.body.appendChild(src)
    true
))(window, document)
