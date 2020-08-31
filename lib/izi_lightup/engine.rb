# frozen_string_literal: true

module IziLightup
  class Engine < ::Rails::Engine
    engine_name 'izi_lightup'

    require_relative 'extentions/autoload_paths'

    config.assets.precompile += %w[
      crit-utils/measure.js
      crit-utils/bundle.js

      loadCSS.js
      cssrelpreload.js
    ]
  end
end
