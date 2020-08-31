# frozen_string_literal: true

module IziLightup
  module InlineAsset
    class << self
      def inline_file(paths, format = nil)
        Array.wrap(paths).map do |asset_path|
          raw_source(with_ext(asset_path, format))
        end.join("\n" * 3)
      end

      def inline_js(paths = [])
        return '' if paths.blank?

        "<script type='text/javascript'>#{inline_file(paths, :js)}</script>"
      end

      def inline_css(paths = [])
        return '' if paths.blank?

        "<style type='text/css'>#{inline_file(paths, :css)}</style>"
      end

      private

      def with_ext(path, format = nil)
        return path if format.nil?

        ext = File.extname(path)
        return path if ext.present?

        "#{path}.#{format}"
      end

      def raw_source(asset_path)
        manifest.find_sources(asset_path).first&.html_safe
      end

      def manifest
        @manifest ||= Rails.application.assets_manifest
      end
    end
  end
end
