(function(window) {
  var LCS_BAD, LCS_OK, MAX_TIMEOUT, TTL_TIMEOUT, __check_offset, __lcs, __print, __ttlTimeout;
  LCS_OK = 0.1;
  LCS_BAD = 0.25;
  TTL_TIMEOUT = 2000;
  MAX_TIMEOUT = 15000;
  __print = function(msg, value) {
    var info_css, result_css, tag, tag_css;
    info_css = 'color: silver;';
    if (value >= LCS_BAD) {
      result_css = 'color: red; font-weight: bold;';
      tag_css = 'color: red; font-weight: bold;';
      tag = 'ERROR';
    } else if (value >= LCS_OK) {
      result_css = 'color: orange; font-style: italic;';
      tag_css = 'color: orange; font-weight: bold;';
      tag = 'WARN';
    } else {
      result_css = 'color: green;';
      tag_css = 'color: green; font-weight: bold;';
      tag = 'OK';
    }
    return console.debug('%cMEASURE: %c<%s> %c%s', info_css, tag_css, tag, result_css, msg);
  };
  __ttlTimeout = void 0;
  __lcs = function() {
    var __finTimeout, __unsub, clsValue, performanceObserver;
    clsValue = 0;
    __unsub = void 0;
    __finTimeout = void 0;
    performanceObserver = new PerformanceObserver(function(performanceEntryList) {
      var entry, i, len, performanceEntries, results;
      performanceEntries = performanceEntryList.getEntries();
      if (__ttlTimeout != null) {
        clearTimeout(__ttlTimeout);
      }
      __ttlTimeout = setTimeout(__unsub, TTL_TIMEOUT);
      results = [];
      for (i = 0, len = performanceEntries.length; i < len; i++) {
        entry = performanceEntries[i];
        if (!entry.hadRecentInput) {
          clsValue += entry.value;
          results.push(__print("lcs updated " + (clsValue.toFixed(3)) + "(+" + (entry.value.toFixed(3)) + ")", clsValue));
        } else {
          results.push(void 0);
        }
      }
      return results;
    });
    console.debug('INIT LCS COUNTER...');
    performanceObserver.observe({
      type: 'layout-shift',
      buffered: true
    });
    __unsub = function() {
      performanceObserver.disconnect('layout-shift');
      __ttlTimeout = void 0;
      if (__finTimeout != null) {
        clearTimeout(__finTimeout);
        __finTimeout = void 0;
      }
      return __print("result " + (clsValue.toFixed(3)), clsValue);
    };
    return __finTimeout = setTimeout(__unsub, MAX_TIMEOUT);
  };
  __check_offset = function() {
    if (window.scrollY <= 300) {
      return setTimeout(__lcs, 1);
    }
  };
  return setTimeout(__check_offset, 1);
})(window);
