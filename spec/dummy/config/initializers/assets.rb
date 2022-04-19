# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

if Rails.env.development? || Rails.env.test?
  Rails.application.config.assets.paths << Rails.root.join('../../spec/javascripts')
end

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w[
  vendor.js
  vendor.css
  critical.css
  critical/welcome.css
  critical/welcome_index.css

  application_spec.js
  support/jasmine-*/*
  fixtures/**/*.json
]
