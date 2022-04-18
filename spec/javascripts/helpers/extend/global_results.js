(function (ctx) {
  function setup(global) {
    global.$status = 'pending';
    global.$completed = false;
    global.$$stdout = '';
    global.$$stderr = '';

    var MAPPING = {
      passed: '+',
      failed: '-',
      pending: '*',
    };

    function dumpSpecResult(result) {
      // console.warn('????', result);
      // result:
      // status: 'passed' | 'failed' | 'pending'
      // fullName: '...'
      // description: '...'
      // failedExpectations: []
      // passedExpectations: []

      if (result.status === 'passed' && result.passedExpectations.length > 0) {
        console.log('PASSED ' + result.fullName);
      } else if (result.status === 'failed') {
        console.log('FAILED ' + result.fullName);
        for (var i = 0; i < result.failedExpectations.length; i++) {
          console.log('  ERROR: ' + result.failedExpectations[i].message);
        }
      }

      global.$$stdout += MAPPING[result.status] + " " + result.fullName + "\n";
    }

    function dumpSpecErrors(result) {
      if (result.failedExpectations.length === 0) return;
      global.$$stderr += "FAILED: " + result.fullName + "\n";
      for (var i = 0; i < result.failedExpectations.length; i++) {
        var item = result.failedExpectations[i];
        global.$$stderr += "  !!! " + item.message + "\n";
        if (item.stack && (item.stack.trim() !== 'at <Jasmine>')) {
          global.$$stderr += "  >>> " + item.stack + "\n";
        }
      }
    }

    jasmine.getEnv().addReporter({
      jasmineDone: function (result) {
        global.$status = result.overallStatus || 'unknown';
        global.$completed = true;
      },
      specDone: function (result) {
        dumpSpecResult(result);
        dumpSpecErrors(result);
      },
    });
  }

  if (typeof globalThis === 'object') return setup(globalThis);
  if (typeof window === 'object') return setup(window);
  setup(ctx);
})(this);
