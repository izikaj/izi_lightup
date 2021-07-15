# Izi Lightup

Utils to speed up page load by using critical css & deferred scripts initialization

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

```bundle exec rake matrix:install```

### run tests

```bundle exec rake matrix:spec```

### Currently testing on versions:

- ruby 2.3.8 + rails 3.2 + sprockets
- ruby 2.3.8 + rails 4.2 + sprockets 3.x
- ruby 2.3.8 + rails 5.0 + sprockets 3.x
- ruby 2.3.8 + rails 5.2 + sprockets 3.x
- ruby 2.5.8 + rails 4.2 + sprockets 3.x/4.x
- ruby 2.5.8 + rails 5.0 + sprockets 3.x/4.x
- ruby 2.5.8 + rails 6.0 + sprockets 3.x/4.x
