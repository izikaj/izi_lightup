((window) -> (
  # LCS COUNTER
  LCS_OK = 0.1
  LCS_BAD = 0.25

  TTL_TIMEOUT = 2000
  MAX_TIMEOUT = 15000

  __print = (msg, value) ->
    info_css = 'color: silver;'

    if value >= LCS_BAD
      result_css = 'color: red; font-weight: bold;'
      tag_css = 'color: red; font-weight: bold;'
      tag = 'ERROR'
    else if value >= LCS_OK
      result_css = 'color: orange; font-style: italic;'
      tag_css = 'color: orange; font-weight: bold;'
      tag = 'WARN'
    else
      result_css = 'color: green;'
      tag_css = 'color: green; font-weight: bold;'
      tag = 'OK'

    console.debug '%cMEASURE: %c<%s> %c%s', info_css, tag_css, tag, result_css, msg

  __ttlTimeout = undefined
  __lcs = ->
    clsValue = 0
    __unsub = undefined
    __finTimeout = undefined

    performanceObserver = new PerformanceObserver (performanceEntryList) ->
      performanceEntries = performanceEntryList.getEntries()

      clearTimeout(__ttlTimeout) if __ttlTimeout?
      __ttlTimeout = setTimeout __unsub, TTL_TIMEOUT
      for entry in performanceEntries
        if !entry.hadRecentInput
          clsValue += entry.value
          __print "lcs updated #{clsValue.toFixed(3)}(+#{entry.value.toFixed(3)})", clsValue

    console.debug 'INIT LCS COUNTER...'
    performanceObserver.observe
      type: 'layout-shift'
      buffered: true

    __unsub = ->
      performanceObserver.disconnect('layout-shift')
      __ttlTimeout = undefined
      if __finTimeout?
        clearTimeout(__finTimeout)
        __finTimeout = undefined
      __print "result #{clsValue.toFixed(3)}", clsValue

    __finTimeout = setTimeout __unsub, MAX_TIMEOUT

  __check_offset = ->
    if window.scrollY <= 300
      # init LCS counter
      setTimeout __lcs, 1

  setTimeout __check_offset, 1
))(window)
