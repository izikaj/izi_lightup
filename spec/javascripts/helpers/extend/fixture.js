(function (self) {
  var $root, $meta, $cache;
  if (typeof document === 'object') {
    $meta = document.querySelector('[name=fixture_root]');
    $root = $meta && $meta.content;
  }
  $root || ($root = '/assets/fixtures/');
  $cache = {};

  function download(path) {
    return new Promise(function (resolve, reject) {
      var xhr = new XMLHttpRequest();
      xhr.open('GET', $root + path, true);
      xhr.onload = function (_e) {
        var result;
        if (xhr.readyState === 4) {
          result = xhr.responseText;
          if (xhr.status === 200) {
            if (/\.json$/.test(path)) {
              try {
                result = JSON.parse(result);
              } catch (error) {
                console.warn('JSON parse error:', error)
              }
            }
            resolve(result);
          } else {
            reject(xhr.statusText);
          }
        }
      };
      xhr.onerror = function (_error) {
        reject(xhr.statusText);
      };
      xhr.send(null);
    });
  }

  function fixture(path) {
    return $cache[path] || ($cache[path] = download(path));
  }

  self.fixture = fixture;
})(this);
