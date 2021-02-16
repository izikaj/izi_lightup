# frozen_string_literal: true

module IziLightup
  module SmartPicture
    class << self
      include ActionView::Helpers::AssetTagHelper

      def render(object, fields = %i[picture], versions = [], params = {})
        return '' if object.blank?

        items = fetch_items(object, fields)
        return '' if items.blank?

        versions = Array.wrap(versions)
        items.each do |item|
          next unless item.respond_to?(:data)

          versions.each do |version_name|
            next unless version_name == :default || item.data.respond_to?(version_name)

            version = version_name == :default ? item.data : item.data.public_send(version_name)
            next unless version_exists?(version)

            url = version.url
            dimensions = safe_dimentions(item, version)
            params.merge!(dimensions) if dimensions.present?

            return image_tag(url, params) unless block_given?

            yield(url, params)
            return ''
          end
        end

        ''
      end

      private

      def version_exists?(version)
        return true if version&.url&.present? && version.url =~ /https?:/

        version&.file&.exists? && version&.url&.present?
      end

      def fallback_dimentions(item)
        [item&.width, item&.height].compact
      end

      def safe_dimentions_extract(item, version)
        begin
          version.dimensions
        rescue MiniMagick::Error => _e
          fallback_dimentions(item)
        end
      end

      def safe_dimentions(item, version)
        dimensions = fallback_dimentions(item) if version.url =~ /https?:/
        dimensions ||= safe_dimentions_extract(item, version)

        return {} if dimensions.blank? || (dimensions.size != 2)

        %i[width height].zip(dimensions).to_h
      end

      def fetch_items(object, fields)
        Array.wrap(fields).map do |name|
          object.respond_to?(name) ? object.public_send(name) : nil
        end.compact
      end
    end
  end
end
