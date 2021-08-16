(function(window) {
  window.waitFor = function(key, deepCheck, interval) {
    return function(success, failed) {
      var _called = false, _timer, _timeouter;

      function stop() {
        if (_timer !== undefined) {
          clearInterval(_timer);
          _timer = undefined;
        }
        if (_timeouter !== undefined) {
          clearTimeout(_timeouter);
          _timeouter = undefined;
        }
      }

      function checker() {
        if (_called || typeof window[key] === 'undefined') {
          return;
        }

        if ((typeof deepCheck === 'function') && !deepCheck.call(window[key])) {
          return;
        }

        stop();
        _called = true;
        if (typeof success === 'function') {
          success.call(window[key], window[key]);
        }
      };

      _timeouter = setTimeout((function () {
        if (!_called) {
          var msg = "not loaded component [" + key + "] in " + waitFor.timeout;
          stop();
          if (typeof failed === 'function') {
            failed.call(this, msg);
          } else {
            console.warn(msg);
          }
        }
      }), waitFor.timeout);
      _timer = setInterval(checker, interval || waitFor.tick);
      checker();
    };
  };
  window.waitFor.timeout = waitFor.timeout || 30000;
  window.waitFor.tick = waitFor.tick || 100;
})(window);
