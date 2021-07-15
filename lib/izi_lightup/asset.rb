# frozen_string_literal: true

module IziLightup
  module Asset
    class << self
      def [](name)
        return cache[name] if cache.key?(name)

        info = ::IziLightup::AssetInfo.new(name, environment: environment, manifest: manifest)
        # clear info if asset not exist
        info = nil unless info.exist?

        cache[name] = info
      end

      private

      def cache
        @cache ||= {}
      end

      def environment?
        app.assets.is_a?(::Sprockets::Environment) ||
          app.assets.is_a?(::Sprockets::CachedEnvironment)
      end

      def manifest?
        app.respond_to?(:assets_manifest) &&
          app.assets_manifest.is_a?(::Sprockets::Manifest)
      end

      def app
        Rails.application
      end

      def manifest
        @manifest ||= find_or_build_assets_manifest
      end

      def environment
        @environment ||= app.assets if environment?
      end

      def find_or_build_assets_manifest
        return app.assets_manifest if manifest?

        env = app.try(:assets).presence || ::Sprockets::Environment.new(Rails.root)
        ::Sprockets::Manifest.new(env, assets_output_dir)
      end

      def assets_output_dir
        @assets_output_dir ||= Rails.root.join('public', assets_prefix)
      end

      def assets_prefix
        app.config.assets.prefix.presence&.gsub(%r{^/}, '') || 'assets'
      end
    end
  end
end
