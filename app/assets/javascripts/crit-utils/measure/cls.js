(function (window) {
  var LCS_BAD, LCS_OK, MAX_TIMEOUT, TTL_TIMEOUT, $$ttlTimeout;
  LCS_OK = 0.1;
  LCS_BAD = 0.25;
  TTL_TIMEOUT = 3000;
  MAX_TIMEOUT = 15000;

  function $$print(msg, value) {
    var info_css, result_css, tag, tag_css;
    info_css = "color: silver;";
    if (value >= LCS_BAD) {
      result_css = "color: red; font-weight: bold;";
      tag_css = "color: red; font-weight: bold;";
      tag = "ERROR";
    } else if (value >= LCS_OK) {
      result_css = "color: orange; font-style: italic;";
      tag_css = "color: orange; font-weight: bold;";
      tag = "WARN";
    } else {
      result_css = "color: green;";
      tag_css = "color: green; font-weight: bold;";
      tag = "OK";
    }
    console.debug("%cMEASURE: %c<%s> %c%s", info_css, tag_css, tag, result_css, msg);
  };

  function $$cls() {
    var $$finTimeout, $perf, clsValue = 0;

    function $$unsub() {
      $perf.disconnect("layout-shift");
      if ($$ttlTimeout) clearTimeout($$ttlTimeout);
      if ($$finTimeout) clearTimeout($$finTimeout);
      $$ttlTimeout = $$finTimeout = undefined;
      $$print("result " + (clsValue.toFixed(3)), clsValue);
    };

    $perf = new PerformanceObserver(function (list) {
      var entries, entry;

      if ($$ttlTimeout) clearTimeout($$ttlTimeout);
      $$ttlTimeout = setTimeout($$unsub, TTL_TIMEOUT);

      entries = list.getEntries();

      for (var i = 0; i < entries.length; i++) {
        entry = entries[i];
        if (entry.hadRecentInput) continue;

        clsValue += entry.value;
        $$print("lcs updated " + (clsValue.toFixed(3)) + "(+" + (entry.value.toFixed(3)) + ")", clsValue);
      }
    });

    console.debug("INIT LCS COUNTER...");
    $perf.observe({
      type: "layout-shift",
      buffered: true
    });

    $$finTimeout = setTimeout($$unsub, MAX_TIMEOUT);
  };

  setTimeout(function () {
    // skip headless
    if (/\bHeadlessChrome\//.test(navigator.userAgent)) return;
    // skip if initial-scrolled
    if (window.scrollY > 300) return;

    $$cls();
  }, 1);
})(window);
