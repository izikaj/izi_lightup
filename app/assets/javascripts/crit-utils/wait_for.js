(function(window) {
  window.waitFor || (window.waitFor = function(key, deepCheck, interval) {
    return function(callback) {
      var _called, _timer, checker;
      _timer = null;
      _called = false;
      setTimeout((function() {
        if (!_called) {
          return console.warn("not loaded component [" + key + "] in " + waitFor.timeout, typeof window[key]);
        }
      }), waitFor.timeout);
      checker = function() {
        if (_called || typeof window[key] === 'undefined') {
          return;
        }
        if (typeof deepCheck === 'function') {
          if (!deepCheck.call(window[key])) {
            return;
          }
        }
        clearInterval(_timer);
        _called = true;
        if (typeof callback !== 'function') {
          return;
        }
        return callback.call(window[key], window[key]);
      };
      _timer = setInterval(checker, interval || waitFor.tick);
      checker();
      return null;
    };
  });
  window.waitFor.timeout = waitFor.timeout || 30000;
  window.waitFor.tick = waitFor.tick || 100;
})(window);
