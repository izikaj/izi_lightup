(function (window, document) {
  window.__required || (window.__required = {});

  function isFn(t) {
    return typeof t === "function";
  }

  function isPres(t) {
    return typeof t === "string" && t.length > 0;
  }

  function $$onload(id) {
    return function (_evt) {
      var cb, req = __required[id];
      if (!req || req.loaded) return;

      req.loaded = true;
      if (!Array.isArray(req.callbacks)) return;

      while (cb = req.callbacks.shift()) {
        if (isFn(cb)) cb.call(window, req);
      }
    }
  }

  function $$on(node, kind, cb) {
    if (!isFn(node[kind])) return;
    node[kind]("load", cb);
  }

  function $$attach(id, node) {
    var cb, req = __required[id];
    if (req.loaded) return;

    cb = node.onload;
    if (isFn(cb)) req.callbacks.push(cb);

    node.onload = cb = $$onload(id);
    $$on(node, "addEventListener", cb);
    $$on(node, "attachEvent", cb);
  }

  function $$sub(id, cb) {
    var req = __required[id];
    if (!req) return;
    if (req.loaded) {
      setTimeout(cb, 1);
    } else if (isFn(cb)) {
      req.callbacks.push(cb);
    }
    return req;
  };

  function uid() {
    return Math.random().toString(36).slice(2, 12);
  }

  function toID(key) {
    return "source_" + (key.replace(/[^a-z0-9_\-]+/ig, "_"));
  }

  window.miniRequire || (window.miniRequire = function (key, src, cb) {
    key || (key = uid());
    var id = toID(key);

    __required[id] || (__required[id] = {
      loaded: false,
      callbacks: [],
      started: false
    });

    if (!isPres(src)) return $$sub(id, cb);
    if (__required[id].started) return $$sub(id, cb);

    __required[id].started = true;
    var node = document.createElement("script");
    node.id = id;
    node.async = true;
    node.defer = true;
    node.src = src;
    __required[id].node = node;
    $$attach(id, node);
    $$sub(id, cb);
    (document.body || document.head).appendChild(node);
    return __required[id]
  });

  window.miniPreload || (window.miniPreload = function (params, cb) {
    if (typeof params === "string") {
      params = {
        src: params
      };
    }
    params.key || (params.key = uid());
    cb || (cb = params.callback);
    var id = toID(params.key);
    __required[id] || (__required[id] = {
      loaded: false,
      callbacks: [],
      started: false
    });

    if (!isPres(params.src)) return $$sub(id, cb);
    if (__required[id].started) return $$sub(id, cb);

    __required[id].started = true;
    var node = document.createElement("link");
    node.id = id;
    node.rel = "preload";
    node.href = params.src;
    node.as = params.as || "style";
    __required[id].node = node;
    $$attach(id, node);
    $$sub(id, cb);
    document.head.appendChild(node);
  });
})(window, document);
