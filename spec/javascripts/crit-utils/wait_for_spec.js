describe("waitFor", function () {
  beforeEach(function () {
    waitFor.tick = 1;
    waitFor.timeout = 100;
  });

  it("should exists as global function", function () {
    expect(waitFor).toBeDefined();
    expect(typeof waitFor).toBe("function");
  });

  describe("callbacks", function () {
    it("should return curried fn to pass callback", function () {
      expect(typeof waitFor("SOMEWHAT")).toBe("function");
    });

    it("should call success callback", function () {
      return new Promise(function (resolve) {
        waitFor("jQuery")(function () {
          expect(jQuery).toBeDefined();
          resolve();
        });
      });
    });

    it("should wait for required global variable", function () {
      var $clock = jasmine.clock();
      $clock.install();
      return new Promise(function (resolve) {
        var KEY = "key" + Math.random();
        expect(window[KEY]).toBeUndefined();
        $clock.tick(500);
        setTimeout(function () {
          window[KEY] = "TODO";
        }, 500);
        $clock.tick(500);
        waitFor(KEY)(function () {
          expect(window[KEY]).toBeDefined();
          $clock.uninstall();
          resolve();
        });
      });
    });

    it("should call fail callback by timeout", function () {
      waitFor.tick = 1;
      waitFor.timeout = 10;
      return new Promise(function (resolve) {
        var KEY = "key" + Math.random();
        expect(window[KEY]).toBeUndefined();
        waitFor(KEY)(function () {
          expect("Should not be called").toBe("");
          resolve();
        }, function (message) {
          expect(window[KEY]).toBeUndefined();
          expect(message).toContain("not loaded component");
          resolve();
        });
      });
    });

    it("should not call success callback if already failed", function () {
      waitFor.tick = 1;
      waitFor.timeout = 10;
      return new Promise(function (resolve) {
        var KEY = "key" + Math.random();
        expect(window[KEY]).toBeUndefined();
        waitFor(KEY)(function () {
          expect("Should not be called").toBe("");
          resolve();
        }, function () {
          window[KEY] = true;
          setTimeout(resolve, 50);
        });
      });
    });
  });

  describe("property: deepCheck", function () {
    it("should allow to pass second prop for deep check", function () {
      var KEY = "key" + Math.random();
      var called = false;
      return new Promise(function (resolve, reject) {
        setTimeout(function () {
          window[KEY] = true;
        }, 5);
        waitFor(KEY, function() {
          return called = true;
        })(function () {
          expect(called).toBeTruthy();
          resolve();
        }, reject);
      });
    });

    it("should call deep check untill it returns true", function () {
      var KEY = "key" + Math.random();
      var count = 0;
      waitFor.timeout = 500;
      return new Promise(function (resolve, reject) {
        setTimeout(function () {
          window[KEY] = true;
        }, 5);
        waitFor(KEY, function() {
          return ++count >= 5;
        })(function () {
          expect(count).toBe(5);
          resolve();
        }, reject);
      });
    });

    it("should not call deep check while no global mark found", function () {
      var KEY = "key" + Math.random();
      var called = false;
      return new Promise(function (resolve, reject) {
        waitFor(KEY, function() {
          return called = true;
        })(reject, function () {
          expect(called).toBeFalsy();
          resolve();
        });
      });
    });
  });

  describe("property: interval", function () {
    it("should allow to pass custom tick interval", function () {
      var count = 0;
      waitFor.tick = 1;
      waitFor.timeout = 100;
      return new Promise(function (resolve, reject) {
        waitFor("window", function () {
          return ++count >= 10;
        }, 50)(reject, function() {
          expect(count).toBeLessThan(5);
          resolve();
        });
      });
    });
  });
});
