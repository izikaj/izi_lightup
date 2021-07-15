# frozen_string_literal: true

require 'fastimage'

module IziLightup
  class AssetInfo
    attr_reader :name, :manifest, :environment

    def initialize(name, manifest: nil, environment: nil)
      @name = name
      @manifest = manifest
      @environment = environment
    end

    def exist?
      @exist ||= check_existence
    end
    alias exists? exist?

    def path
      @path ||= detect_path
    end

    def content_type
      @content_type ||= detect_content_type
    end

    def type
      return unless exist?

      @type ||= FastImage.type(path)
    end

    def size
      @size ||= detect_size
    end
    alias dimentions size

    private

    def check_existence
      env_asset.present? || manifest&.assets&.key?(name)
    end

    def detect_path
      return unless exist?

      env_pathname.presence || assets_output_dir.join(final_asset_name)
    end

    def detect_content_type
      return unless exist?

      env_asset&.content_type.presence ||
        Mime::Type.lookup_by_extension(FastImage.type(path)).to_s
    end

    def detect_size
      return unless exist?

      FastImage.size(path)
    end

    def env_pathname
      return unless env_asset
      return env_asset.pathname if env_asset.respond_to?(:pathname)
      return Pathname.new(env_asset.filename) if env_asset.respond_to?(:filename)

      nil
    end

    def env_asset
      @env_asset ||= environment&.find_asset(name)
    end

    def environment?
      environment.present?
    end

    def manifest?
      manifest.present?
    end

    def final_asset_name
      return name if environment?

      manifest.assets[name] if manifest.assets.present?
    end

    def assets_output_dir
      @assets_output_dir ||= Pathname.new(manifest&.dir.presence || Rails.root.join('public', assets_prefix))
    end

    def assets_prefix
      Rails.application.config.assets.prefix.presence&.gsub(%r{^/}, '') || 'assets'
    end
  end
end
