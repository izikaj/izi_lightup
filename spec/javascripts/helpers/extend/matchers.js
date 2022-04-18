function isNil(value) {
  return (value === undefined) || (value === null);
}

function isBlank(value) {
  if (isNil(value)) {
    return true;
  }
  switch (typeof value) {
    case 'string':
      return value.trim().length === 0;
    case 'number':
      return value !== 0 && !value;
    case 'object':
      if (Array.isArray(value)) {
        return value.length === 0;
      } else {
        return Object.getOwnPropertyNames(value).length === 0
      }
    default:
      return !value;
  }
}

beforeEach(function () {
  jasmine.addMatchers({
    toBeNil: function () {
      return {
        compare: function (actual, _expected) {
          return { pass: isNil(actual) };
        }
      };
    },
    toBeFunction: function () {
      return {
        compare: function (actual, _expected) {
          return { pass: typeof actual === 'function' };
        }
      };
    },
    toBeBlank: function () {
      return {
        compare: function (actual, _expected) {
          return { pass: isBlank(actual) };
        }
      };
    },
    toBePresent: function () {
      return {
        compare: function (actual, _expected) {
          return { pass: !isBlank(actual) };
        }
      };
    }
  });
});
