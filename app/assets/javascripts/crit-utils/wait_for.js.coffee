((window) -> (
  window.waitFor ||= (key, deepCheck, interval) ->
    (callback) ->
      _timer = null
      _called = false
      setTimeout (->
          unless _called
            console.warn "not loaded component [#{key}] in #{waitFor.timeout}", typeof window[key]
        ), waitFor.timeout
      checker = ->
        return if _called || typeof window[key] is 'undefined'

        if typeof deepCheck is 'function'
          return unless deepCheck.call(window[key])

        clearInterval(_timer)
        _called = true
        return unless typeof callback is 'function'
        callback.call(window[key], window[key])

      _timer = setInterval(checker, interval || waitFor.tick)

      checker()
      null

  window.waitFor.timeout ||= 30000
  window.waitFor.tick ||= 100
))(window)
