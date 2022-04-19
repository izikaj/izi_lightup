(function (self) {
  function isItemMatched(item, matcher, attribute) {
    var value = typeof attribute === undefined ? item : item[attribute];
    if (typeof matcher === "function") {
      return matcher.call(items, value);
    }

    if (typeof matcher === "object" && RegExp.prototype.isPrototypeOf(matcher)) {
      if (typeof value !== "string") value = value.toString();

      return matcher.test(value);
    }

    return matcher == value;
  }

  self.detectItem = function (items, matcher, attribute) {
    if (!Array.isArray(items)) return;

    for (var i = 0; i < items.length; i++) {
      if (isItemMatched(items[i], matcher, attribute)) {
        return items[i];
      }
    }
  };

  self.detectByTitle = function (items, matcher) {
    return self.detectItem(items, matcher, "title");
  };
})(this);
