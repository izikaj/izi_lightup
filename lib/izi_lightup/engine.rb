# frozen_string_literal: true

module IziLightup
  # GEM engine
  class Engine < ::Rails::Engine
    engine_name 'izi_lightup'

    require_relative 'extentions/autoload_paths'

    initializer 'izi_lightup.assets.precompile' do |app|
      app.config.assets.precompile += %w[
        crit-utils/measure.js
        crit-utils/bundle.js

        loadCSS.js
        cssrelpreload.js
        crit-utils/async-css.js
      ]
    end
  end
end
