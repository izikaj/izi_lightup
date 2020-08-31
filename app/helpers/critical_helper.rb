# frozen_string_literal: true

module CriticalHelper
  def css_preload(name)
    link = content_tag :link, '', rel: 'preload', href: stylesheet_path(name), as: 'style', onload: 'this.rel="stylesheet"'
    noscript = content_tag :noscript do
      content_tag :link, '', rel: 'stylesheet', href: stylesheet_path(name)
    end

    link + noscript
  end

  def inline_js(name)
    IziLightup::InlineAsset.inline_js(name).html_safe
  end

  def inline_css(name)
    raw = IziLightup::InlineAsset.inline_css(name).html_safe
    raw = "<!-- CRIT CSS: #{name} -->".html_safe + raw if Rails.env.development?
    raw
  end

  def critical_js
    inline_js('crit-utils/bundle.js').presence || '<!-- CRIT JS NOT FOUND! -->'.html_safe
  end

  def critical_css
    name = find_scoped_css('critical')
    return '<!-- CRIT CSS NOT FOUND! -->'.html_safe if name.blank?

    return inline_css(name) if Rails.env.production?

    # inject measure js for development
    inline_css(name) + inline_js('utils/measure.js')
  end

  def smart_picture(object, fields = %i[picture], versions = [], params = {})
    return '' if object.blank?

    IziLightup::SmartPicture.render(object, fields, versions, params)
  end

  private

  def find_scoped_css(scope_name)
    [
      File.join(scope_name, "#{controller_path}_#{action_name}.css"),
      File.join(scope_name, "#{controller_path}.css"),
      File.join(scope_name, "#{controller_name}_#{action_name}.css"),
      File.join(scope_name, "#{controller_name}.css"),
      "#{scope_name}.css"
    ].detect { |n| asset_exist?(n) }
  end

  def fetch_items(object, fields)
    Array.wrap(fields).map do |name|
      object.respond_to?(name) ? object.public_send(name) : nil
    end.compact
  end

  def asset_exist?(name)
    Rails.application.assets_manifest.find_sources(name)&.first&.present?
  end
end
