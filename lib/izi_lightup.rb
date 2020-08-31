# frozen_string_literal: true

require 'izi_lightup/version'
require 'pathname'

module IziLightup
  class << self
    def configure
      yield self
    end
  end

  autoload :InlineAsset, 'izi_lightup/inline_asset'
  autoload :SmartPicture, 'izi_lightup/smart_picture'

  class << self
    def root_path
      @root_path ||= Pathname.new(File.dirname(File.expand_path(__dir__)))
    end
  end
end

require 'izi_lightup/engine'
