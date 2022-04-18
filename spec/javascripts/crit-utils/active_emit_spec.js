describe("activeOn", function () {
  it("should exists as global function", function () {
    expect(activeOn).toBeDefined();
    expect(typeof activeOn).toBe("function");
  });

  it("should call callback", function () {
    return new Promise(function (resolve, _reject) {
      var emitted = false;
      activeOn.$$mock(function () {
        emitted = true;
        $("body").trigger("click");
      });
      activeOn(function () {
        expect(emitted).toBeTruthy();
        resolve();
      });
    });
  });

  it("should call on timeout", function () {
    window.__activeTimeout = 1;
    return new Promise(function (resolve, reject) {
      var emitter = setTimeout(function () {
        reject("Should not have been called");
      }, 100);
      window.__activeTimeout = 1;
      activeOn.$$mock();
      activeOn(function () {
        expect("activeReady").toBeTruthy();
        clearTimeout(emitter);
        resolve();
      });
    });
  });
});
