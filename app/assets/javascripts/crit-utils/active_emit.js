(function(window, document) {
  var EVENT_TYPE, MAX_TIMEOUT, TRACK_MARKING, activeForUser, cleanListeners, custom_mt, sendActive, sent;
  EVENT_TYPE = window.__activeEventName || 'Activity';
  MAX_TIMEOUT = window.__activeTimeout || 10000;
  TRACK_MARKING = window.__activeMark || '_real_track=true';
  if (custom_mt = /^\?(\d+)$/.exec(window.location.search)) {
    MAX_TIMEOUT = parseInt(custom_mt[1], 10);
  }
  window.activeReady = false;
  sent = false;
  window.activeOn = function(callback, onIddle) {
    var fn;
    if (typeof onIddle !== 'boolean') {
      onIddle = false;
    }

    function emit() {
      if (typeof callback !== 'function') {
        return;
      }
      if (typeof requestIdleCallback === 'function' && onIddle) {
        return requestIdleCallback(callback);
      }
      if (typeof requestAnimationFrame === 'function') {
        return requestAnimationFrame(callback);
      }
      callback();
    }

    if (sent) {
      return emit();
    }

    fn = function() {
      document.removeEventListener(EVENT_TYPE, fn);
      emit();
    };
    return document.addEventListener(EVENT_TYPE, fn, { passive: true });
  };

  sendActive = function() {
    if (sent) {
      return;
    }
    sent = true;
    try {
      document.dispatchEvent(new Event(EVENT_TYPE));
    } catch (_error) {
      (function() {
        var oldEvt;
        oldEvt = document.createEvent('CustomEvent');
        oldEvt.initCustomEvent(EVENT_TYPE, true, true, {});
        document.dispatchEvent(oldEvt);
      })();
    }
    window.activeReady = true;
  };

  activeForUser = function() {
    document.cookie = TRACK_MARKING + ";path=/;max-age:31536000;samesite";
    if (typeof cleanListeners === "function") {
      cleanListeners();
    }
    sendActive();
  };

  window.activeOn.untrack = function() {
    var expTime;
    expTime = new Date();
    expTime.setTime(0);
    document.cookie = TRACK_MARKING + ";expires=" + (expTime.toGMTString());
  };

  if (document.cookie.indexOf(TRACK_MARKING) !== -1) {
    setTimeout(sendActive, 10);
    return;
  }

  document.addEventListener('DOMContentLoaded', function() {
    var body, evt, i, lEvents, len;
    body = document.body;
    lEvents = [[body, 'mousemove'], [body, 'scroll'], [body, 'keydown'], [body, 'click'], [body, 'touchstart'], [window, 'blur'], [window, 'focus']];
    cleanListeners = function() {
      var evt, i, len;
      for (i = 0, len = lEvents.length; i < len; i++) {
        evt = lEvents[i];
        evt[0].removeEventListener(evt[1], activeForUser);
      }
    };
    for (i = 0, len = lEvents.length; i < len; i++) {
      evt = lEvents[i];
      evt[0].addEventListener(evt[1], activeForUser, {
        passive: true
      });
    }
    setTimeout(sendActive, MAX_TIMEOUT, { passive: true });
  });
})(window, document);
