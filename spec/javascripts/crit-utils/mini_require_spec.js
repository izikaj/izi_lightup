describe("require", function () {
  function $$clean() {
    for (var key in window.__required) {
      if (__required[key].node) __required[key].node.remove();

      delete(__required[key]);
    }
  }

  afterEach(function () {
    $$clean();
  });

  describe("miniRequire", function () {
    function $$items() {
      return document.scripts;
    }

    it("should exists as global function", function () {
      expect(miniRequire).toBeDefined();
      expect(typeof miniRequire).toBe("function");
    });

    it("should inject new script", function () {
      var cnt = $$items().length;
      miniRequire("todo", "/assets/application.js");
      expect($$items().length - cnt).toBe(1);
    });

    it("should inject only one script tag", function () {
      var cnt = $$items().length;
      miniRequire("todo", "/assets/application.js");
      miniRequire("todo", "/assets/application.js");
      miniRequire("todo", "/assets/application.js");
      expect($$items().length - cnt).toBe(1);
    });

    it("should return subscription", function () {
      var sub = miniRequire("todo", "/assets/application.js");
      expect(sub).toBePresent();
      expect(sub.started).toBeTruthy();
      expect(sub.loaded).toBeFalsy();
      expect(sub.node).toBeDefined();
    });

    it("should call callback once script loaded", function () {
      return new Promise(function (resolve) {
        delete window["APPLICATION_JS"];
        var sub = miniRequire("todo", "/assets/application.js", function () {
          expect(sub.started).toBeTruthy();
          expect(sub.loaded).toBeTruthy();
          expect(window["APPLICATION_JS"]).toBe("TODO");
          resolve();
        });
      });
    });

    it("should add subscription only if no src provided", function () {
      return new Promise(function (resolve) {
        delete window["APPLICATION_JS"];
        var cnt = $$items().length;
        // add subscription
        miniRequire("todo", undefined, function () {
          expect(window["APPLICATION_JS"]).toBe("TODO");
          resolve();
        });
        expect($$items().length - cnt).toBe(0);
        // and require script later
        setTimeout(function () {
          miniRequire("todo", "/assets/application.js");
          expect($$items().length - cnt).toBe(1);
        }, 10);
      });
    });

    it("should resolve at minium time if already loaded", function () {
      return new Promise(function (resolve) {
        var loaded1, loaded2;
        miniRequire("todo", "/assets/application.js", function () {
          expect(window["APPLICATION_JS"]).toBe("TODO");
          loaded1 = (new Date()).getTime();
          miniRequire("todo", "/assets/application.js", function () {
            loaded2 = (new Date()).getTime();
            expect(loaded2 - loaded1).toBeLessThan(100);
          });
          resolve();
        });
      });
    });
  });

  describe("miniPreload", function () {
    function $$items() {
      return document.querySelectorAll("link[rel=preload]");
    }

    it("should exists as global function", function () {
      expect(miniPreload).toBeDefined();
      expect(typeof miniPreload).toBe("function");
    });

    it("should inject new link tag", function () {
      var cnt = $$items().length;
      miniPreload("/assets/application.js");
      expect($$items().length - cnt).toBe(1);
    });

    it("should call callback with context once loaded", function () {
      return new Promise(function (resolve) {
        miniPreload("/assets/application.js", function(ctx) {
          expect(ctx).toBePresent();
          expect(ctx.node).toBeDefined();
          resolve();
        });
      });
    });
  });
});
