module.exports = function (config) {
  config.set({
    basePath: '',
    frameworks: ['jasmine'],
    files: [
      {
        pattern: 'spec/dummy/app/assets/javascripts/application.js',
        watched: true,
        included: false,
        served: true,
        nocache: false
      },
      'spec/javascripts/helpers/vendor/jquery.js',
      'spec/javascripts/helpers/**/*.js',
      'app/assets/javascripts/crit-utils/**/*.js',
      'spec/javascripts/**/*.js',
    ],
    proxies: {
      "/assets/": "/base/spec/dummy/app/assets/javascripts/"
    },
    exclude: [
      'app/assets/javascripts/crit-utils/**/*.min.js',
      'spec/javascripts/support/jasmine-*/**/*.*',
    ],
    preprocessors: {},
    // test results reporter to use
    // possible values: 'dots', 'progress'
    // available reporters: https://www.npmjs.com/search?q=keywords:karma-reporter
    reporters: ['dots'],
    port: 9876,
    colors: true,
    logLevel: config.LOG_INFO,
    autoWatch: false,
    browsers: ['ChromeHeadless'],
    singleRun: true,
    concurrency: Infinity
  })
}
