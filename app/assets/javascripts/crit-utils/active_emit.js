(function(window, document) {
  var EVENT_TYPE, MAX_TIMEOUT, TRACK_MARKING, activeForUser, cleanListeners, custom_mt, sendActive, sent, untrack;
  EVENT_TYPE = window.__activeEventName || 'Activity';
  MAX_TIMEOUT = window.__activeTimeout || 10000;
  TRACK_MARKING = window.__activeMark || '_real_track=true';
  if (custom_mt = /^\?(\d+)$/.exec(window.location.search)) {
    MAX_TIMEOUT = parseInt(custom_mt[1], 10);
  }
  window.activeReady = false;
  sent = false;
  window.activeOn = function(callback) {
    var fn;
    if (sent) {
      if (typeof callback !== 'function') {
        return;
      }
      if ((window != null ? window.requestAnimationFrame : void 0) != null) {
        return requestAnimationFrame(callback);
      }
      callback();
    }
    fn = function() {
      document.removeEventListener(EVENT_TYPE, fn);
      if (typeof callback !== 'function') {
        return;
      }
      if ((window != null ? window.requestAnimationFrame : void 0) != null) {
        return requestAnimationFrame(callback);
      }
      return callback();
    };
    return document.addEventListener(EVENT_TYPE, fn, {
      passive: true
    });
  };
  cleanListeners = void 0;
  sendActive = function() {
    var oldEvt;
    if (sent) {
      return;
    }
    sent = true;
    try {
      document.dispatchEvent(new Event(EVENT_TYPE));
    } catch (_error) {
      oldEvt = document.createEvent('CustomEvent');
      oldEvt.initCustomEvent(EVENT_TYPE, true, true, {});
      document.dispatchEvent(oldEvt);
    }
    return window.activeReady = true;
  };
  activeForUser = function() {
    document.cookie = TRACK_MARKING + ";path=/;max-age:31536000;samesite";
    if (typeof cleanListeners === "function") {
      cleanListeners();
    }
    return sendActive();
  };
  untrack = function() {
    var expTime;
    expTime = new Date();
    expTime.setTime(0);
    return document.cookie = TRACK_MARKING + ";expires=" + (expTime.toGMTString());
  };
  if (document.cookie.indexOf(TRACK_MARKING) !== -1) {
    setTimeout(sendActive, 10);
    window.activeOn.untrack = untrack;
    return;
  }
  return document.addEventListener('DOMContentLoaded', function() {
    var body, evt, i, lEvents, len;
    body = document.body;
    lEvents = [[body, 'mousemove'], [body, 'scroll'], [body, 'keydown'], [body, 'click'], [body, 'touchstart'], [window, 'blur'], [window, 'focus']];
    cleanListeners = function() {
      var evt, i, len, results;
      results = [];
      for (i = 0, len = lEvents.length; i < len; i++) {
        evt = lEvents[i];
        results.push(evt[0].removeEventListener(evt[1], activeForUser));
      }
      return results;
    };
    for (i = 0, len = lEvents.length; i < len; i++) {
      evt = lEvents[i];
      evt[0].addEventListener(evt[1], activeForUser, {
        passive: true
      });
    }
    return setTimeout(sendActive, MAX_TIMEOUT, {
      passive: true
    });
  });
})(window, document);

// ---
// generated by coffee-script 1.9.2