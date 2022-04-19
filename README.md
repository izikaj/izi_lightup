# Izi Lightup

Utils to speed up page load by using critical css & deferred scripts initialization

## Usage

### JS utils

#### activeOn
```JavaScript
activeOn(function() {
  console.log("should activate large client oriented JS here");
});
```

#### waitFor
```JavaScript
waitFor("jQuery", function() {
  $("body").css("background", "orange");
});
waitFor("jQuery", function() { return $.fn && $.fn.select2 }, function() {
  $("select").select2();
});
```

#### miniRequire
```JavaScript
miniRequire("main-bundle", "/assets/application.js");
var src = "https://cdnjs.cloudflare.com/ajax/libs/tooltipster/4.2.8/js/tooltipster.bundle.min.js"
miniRequire("main-bundle", src, function() {
  $('.tooltip').tooltipster();
});
```

#### miniPreload
```JavaScript
miniPreload("/assets/font.woff2");
miniPreload("/assets/extra.css", function(ctx) {
  ctx.node.rel = "stylesheet";
});
```

## Requirements

- ruby 2.3+
- rails 3.x+ with sprockets 2.x+

## Development

### Changelog

- Add support for rails 3.2 (ruby 2.3.8 + rails 3.2 + sprockets 2.2)
- Add multiple dependencies/rubies versions tests
- Add tests

### TODO

- Add more JS-plugins
- Add tests to cover JS-code
- Refactor JS-code
- Add some docs/examples
- Add fast-image gem for images size detection
- Add more tests

### install deps

```sh
bundle exec rake matrix:install
```

### run tests

#### Rspec
```sh
bundle exec rake matrix:spec
```

#### Karma
```sh
npm test
or
npm test:karma
```

#### All in one (karma + current rspec)
```sh
npm test:all
```

#### Run karma in browser
```sh
bundle exec rails server
```
and visit root page of server

### Currently testing on versions:

- ruby 2.3.8 + rails 3.2 + sprockets
- ruby 2.3.8 + rails 4.2 + sprockets 3.x
- ruby 2.3.8 + rails 5.0 + sprockets 3.x
- ruby 2.3.8 + rails 5.2 + sprockets 3.x
- ruby 2.5.8 + rails 4.2 + sprockets 3.x/4.x
- ruby 2.5.8 + rails 5.0 + sprockets 3.x/4.x
- ruby 2.5.8 + rails 6.0 + sprockets 3.x/4.x
