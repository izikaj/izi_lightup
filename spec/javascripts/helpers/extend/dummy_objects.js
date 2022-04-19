function dummyEvent(opts) {
  return angular.extend({
    preventDefault: function () {},
    stopPropagation: function () {}
  }, opts || {});
}

function dummyNgForm(opts) {
  return angular.extend({
    $valid: true,
    $setSubmitted: function () {},
  }, opts || {});
}

function mockedDeferredFn() {
  var res, promise, $resolve, $reject;
  res = function () {
    res.$$args = arguments;

    return promise = new Promise(function (resolve, reject) {
      $resolve = resolve;
      $reject = reject;
    });
  }
  res.$resolve = function (data) {
    $resolve(data);
    return promise;
  };
  res.$reject = function (data) {
    $reject(data);
    return promise.catch(function (r) {
      return r;
    });
  };
  return res;
}

function $appInject() {
  var deps, mapping;
  deps = [];
  mapping = {};
  angular.forEach(arguments, function (value, key) {
    if (typeof key === "number") key = value;
    deps.push(value);
    mapping[value] = key;
  });

  return new Promise(function (resolve) {
    var $API = {};
    deps.push(function () {
      angular.forEach(arguments, function (value, index) {
        $API[mapping[deps[index]]] = value;
      });

      resolve($API);
    });

    module("EssayApp");
    inject(deps);
  });
}

function $sandbox(uid) {
  uid || (uid = "ng-sandbox");
  return setFixtures(
    "<div id=\"" + uid + "\" style=\"width:1px;height:1px;overflow:hidden;opacity:0.001;\"></div>"
  ).find("#" + uid);
}

// TODO: refactor $progress to remove artifacts on scope $destroy event
afterEach(function () {
  $(".ngProgress-container").remove();
});
