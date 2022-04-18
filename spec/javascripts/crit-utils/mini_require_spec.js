describe("miniRequire", function () {
  it("should exists as global function", function () {
    expect(miniRequire).toBeDefined();
    expect(typeof miniRequire).toBe("function");
  });
});
describe("miniPreload", function () {
  it("should exists as global function", function () {
    expect(miniPreload).toBeDefined();
    expect(typeof miniPreload).toBe("function");
  });
});
