((window, document) -> (
  EVENT_TYPE = window.__activeEventName || 'Activity'
  MAX_TIMEOUT = window.__activeTimeout || 10000
  TRACK_MARKING = window.__activeMark || '_real_track=true'

  if custom_mt = /^\?(\d+)$/.exec(window.location.search)
    MAX_TIMEOUT = parseInt(custom_mt[1], 10)

  window.activeReady = false
  sent = false
  window.activeOn = (callback) ->
    if sent
      return if typeof(callback) isnt 'function'
      return requestAnimationFrame(callback) if window?.requestAnimationFrame?
      callback()

    fn = ->
      document.removeEventListener EVENT_TYPE, fn
      return if typeof(callback) isnt 'function'
      return requestAnimationFrame(callback) if window?.requestAnimationFrame?
      callback()

    document.addEventListener(EVENT_TYPE, fn, {passive: true})

  cleanListeners = undefined

  sendActive = ->
    return if sent
    sent = true
    try
      document.dispatchEvent(new Event(EVENT_TYPE))
    catch
      oldEvt = document.createEvent('CustomEvent')
      oldEvt.initCustomEvent(EVENT_TYPE, true, true, {})
      document.dispatchEvent(oldEvt)

    window.activeReady = true

  activeForUser = ->
    document.cookie = "#{TRACK_MARKING};path=/;max-age:31536000;samesite"
    cleanListeners?()
    sendActive()

  untrack = ->
    expTime = new Date()
    expTime.setTime(0)
    document.cookie = "#{TRACK_MARKING};expires=#{expTime.toGMTString()}"

  if document.cookie.indexOf(TRACK_MARKING) isnt -1
    setTimeout sendActive, 10

    window.activeOn.untrack = untrack
    return

  document.addEventListener 'DOMContentLoaded', ->
    body = document.body
    lEvents = [
      [body, 'mousemove'],
      [body, 'scroll'],
      [body, 'keydown'],
      [body, 'click'],
      [body, 'touchstart'],
      [window, 'blur'],
      [window, 'focus'],
    ];
    cleanListeners = ->
      evt[0].removeEventListener(evt[1], activeForUser) for evt in lEvents

    for evt in lEvents
      evt[0].addEventListener(evt[1], activeForUser, {passive: true})

    setTimeout(sendActive, MAX_TIMEOUT, {passive: true})
))(window, document)
