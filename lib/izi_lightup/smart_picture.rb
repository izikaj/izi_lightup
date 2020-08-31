# frozen_string_literal: true

module IziLightup
  module SmartPicture
    include ActionView::Helpers::AssetTagHelper

    class << self
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
            next if version&.url&.blank?

            url = version.url
            params.merge!(%i[width height].zip(version.dimensions).to_h)
            return image_tag(url, params) unless block_given?

            yield(url, params)
            return ''
          end
        end

        ''
      end
    end
  end
end
