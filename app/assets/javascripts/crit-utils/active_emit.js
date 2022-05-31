(function (window, document) {
  var EVENT_TYPE, MAX_TIMEOUT, TRACK_MARKING, LAZY_EVENTS, $$PASSIVE;
  EVENT_TYPE = window.__activeEventName || "Activity";
  MAX_TIMEOUT = window.__activeTimeout || 10000;
  TRACK_MARKING = window.__activeMark || "_real_track=true";
  LAZY_EVENTS = [
    ["body", "mousemove"],
    ["body", "scroll"],
    ["body", "keydown"],
    ["body", "click"],
    ["body", "touchstart"],
    ["window", "blur"],
    ["window", "focus"]
  ];
  $$PASSIVE = {
    passive: true
  };

  // override max timeout for extra debugging
  var cmt;
  if (cmt = /^\?(\d+)$/.exec(location.search)) MAX_TIMEOUT = parseInt(cmt[1], 10);

  window.activeReady = false;
  var sent = false;

  function isFn(t) {
    return typeof t === "function";
  }

  function $$sendActive() {
    if (sent) return;

    sent = true;
    try {
      document.dispatchEvent(new Event(EVENT_TYPE));
    } catch (_error) {
      if (window.jQuery && jQuery.Event) $(document).trigger(new jQuery.Event(EVENT_TYPE));
    }
    window.activeReady = true;
  };

  function eTarget(kind) {
    if (kind == "body") return document.body;

    return window;
  }

  function cleanListeners() {
    for (var i = 0, len = LAZY_EVENTS.length; i < len; i++) {
      eTarget(LAZY_EVENTS[i][0]).removeEventListener(LAZY_EVENTS[i][1], $$activeForUser);
    }
  };

  function attachListeners() {
    for (var i = 0, len = LAZY_EVENTS.length; i < len; i++) {
      eTarget(LAZY_EVENTS[i][0]).addEventListener(LAZY_EVENTS[i][1], $$activeForUser, $$PASSIVE);
    }
    setTimeout($$sendActive, MAX_TIMEOUT);
  };

  function $$activeForUser() {
    document.cookie = TRACK_MARKING + ";path=/;max-age:31536000;samesite";
    if (isFn(cleanListeners)) cleanListeners();
    $$sendActive();
  };

  window.activeOn = function (callback, onIddle) {
    function emit() {
      if (!isFn(callback)) return;
      if (isFn(window.requestIdleCallback) && onIddle) return requestIdleCallback(callback);
      if (onIddle) return setTimeout(callback, 50);
      if (isFn(window.requestAnimationFrame)) return requestAnimationFrame(callback);

      callback();
    }

    function $$fn() {
      document.removeEventListener(EVENT_TYPE, $$fn);
      emit();
    };

    if (typeof onIddle !== "boolean") onIddle = false;
    if (sent) return emit();

    document.addEventListener(EVENT_TYPE, $$fn, $$PASSIVE);
  };

  window.activeOn.untrack = function () {
    document.cookie = TRACK_MARKING + ";path=/;expires=Thu, 01 Jan 1970 00:00:00 GMT";
  };

  window.activeOn.$$mock = function (cb) {
    cleanListeners();
    activeOn.untrack();
    window.activeReady = false;
    MAX_TIMEOUT = window.__activeTimeout || MAX_TIMEOUT;
    sent = false;
    attachListeners();
    if (isFn(cb)) cb();
  };

  function $$waitForActivity() {
    if (document.cookie.indexOf(TRACK_MARKING) !== -1) return setTimeout($$sendActive, 10);

    document.addEventListener("DOMContentLoaded", attachListeners);
  }

  $$waitForActivity();
})(window, document);
