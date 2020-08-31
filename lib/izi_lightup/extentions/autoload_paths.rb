# frozen_string_literal: true

# isolate_namespace IziLightup
IziLightup::Engine.config.autoload_paths += %W[
  #{IziLightup.root_path}/app/helpers
]
