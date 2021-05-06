(function(window, document) {
  var _buildSubscriptions, _onload, _subscribe;
  window.__required || (window.__required = {});
  _onload = function(id) {
    var callback, callbacks, results;
    if (typeof __required[id] === 'undefined' || __required[id].loaded) {
      return;
    }
    __required[id].loaded = true;
    callbacks = __required[id].callbacks;
    if (!Array.isArray(callbacks)) {
      return;
    }
    results = [];
    while (callbacks.length > 0) {
      callback = callbacks.shift();
      if (typeof callback === 'function') {
        results.push(callback.call(window, __required[id]));
      } else {
        results.push(void 0);
      }
    }
    return results;
  };
  _buildSubscriptions = function(id, node) {
    var callback, data;
    data = __required[id];
    if (data.loaded) {
      return;
    }
    callback = node.onload;
    node.onload = function() {
      return _onload(id);
    };
    if (typeof node.addEventListener === 'function') {
      node.addEventListener('load', function() {
        return _onload(id);
      });
    }
    if (typeof node.attachEvent === 'function') {
      node.attachEvent('load', function() {
        return _onload(id);
      });
    }
    if (typeof callback === 'function') {
      return data.callbacks.push(callback);
    }
  };
  _subscribe = function(id, callback) {
    var data;
    if (typeof __required[id] === 'undefined') {
      return;
    }
    data = __required[id];
    if (data.loaded) {
      return setTimeout(callback, 0);
    }
    if (typeof callback === 'function') {
      return data.callbacks.push(callback);
    }
  };
  window.miniRequire || (window.miniRequire = function(key, source_url, callback) {
    var id, src;
    if (callback == null) {
      callback = void 0;
    }
    key || (key = Math.random().toString(36).slice(2, 12));
    id = "source_" + (key.replace(/[^a-z0-9_\-]+/ig, '_'));
    __required[id] || (__required[id] = {
      loaded: false,
      callbacks: [],
      started: false
    });
    if (!((source_url != null ? source_url.length : void 0) > 0)) {
      return _subscribe(id, callback);
    }
    if (__required[id].started) {
      return _subscribe(id, callback);
    }
    __required[id].started = true;
    src = document.createElement('script');
    src.id = id;
    src.async = true;
    src.defer = true;
    src.src = source_url;
    __required[id].node = src;
    _buildSubscriptions(id, src);
    _subscribe(id, callback);
    document.body.appendChild(src);
    return true;
  });
  return window.miniPreload || (window.miniPreload = function(params, callback) {
    var id, key, source_url, src;
    if (callback == null) {
      callback = void 0;
    }
    key = params.key || Math.random().toString(36).slice(2, 12);
    callback || (callback = params.callback);
    source_url = params.src;
    id = "source_" + (key.replace(/[^a-z0-9_\-]+/ig, '_'));
    __required[id] || (__required[id] = {
      loaded: false,
      callbacks: [],
      started: false
    });
    if (!((source_url != null ? source_url.length : void 0) > 0)) {
      return _subscribe(id, callback);
    }
    if (__required[id].started) {
      return _subscribe(id, callback);
    }
    __required[id].started = true;
    src = document.createElement('link');
    src.id = id;
    src.rel = 'preload';
    src.href = source_url;
    src.as = params.as || 'style';
    __required[id].node = src;
    _buildSubscriptions(id, src);
    _subscribe(id, callback);
    document.head.appendChild(src);
    return true;
  });
})(window, document);
