# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'izi_lightup/version'

Gem::Specification.new do |s|
  s.name = 'izi_lightup'
  s.version = IziLightup::VERSION.dup
  s.platform = Gem::Platform::RUBY
  s.licenses = %w[MIT]
  s.summary = 'Izi Lightup'
  s.description = 'Utils to speed up page load by using critical css &
                  deferred scripts initialization'
  s.authors = %w[IzikAJ]
  s.email = 'izikaj@gmail.com'
  s.homepage = 'https://bitbucket.org/netfixllc/izi_lightup'

  s.files = Dir['{app,config,db,lib,vendor/assets}/**/*'] + %w[README.rdoc]
  s.test_files = Dir['{spec}/**/*']
  s.require_paths = ['lib']

  s.add_runtime_dependency('rails', '>= 3.0.0')
  s.add_development_dependency('byebug')
  s.add_development_dependency('guard-rspec')
  s.add_development_dependency('rspec-html-matchers')
  s.add_development_dependency('rspec-rails')
end
