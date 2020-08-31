# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'izi_lightup/version'

Gem::Specification.new do |s|
  s.name = 'izi_lightup'
  s.version = IziLightup::VERSION.dup
  s.platform = Gem::Platform::RUBY
  s.summary = 'Izi Lightup'
  s.description = 'Utils to speed up page load by using critical css &
                  deferred scripts initialization'
  s.authors = ['IzikAJ']
  s.email = 'izikaj@gmail.com'
  s.homepage = 'https://bitbucket.org/netfixllc/izi_lightup'

  s.files = Dir['{app,config,db,lib,vendor/assets}/**/*'] + ['README.rdoc']
  s.test_files = Dir['{spec}/**/*']
  s.require_paths = ['lib']

  # s.add_runtime_dependency('rails', '~> 4.2.0')
  # s.add_development_dependency('rspec-rails', '~> 3.4.0')
end
