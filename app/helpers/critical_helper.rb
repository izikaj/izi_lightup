# frozen_string_literal: true

module CriticalHelper
  def css_preload(names)
    return '' if names.blank?
    names = Array.wrap(names)

    link = stylesheet_link_tag(*names, rel: 'preload', as: 'style', onload: 'this.rel="stylesheet"')
    noscript = content_tag :noscript do
      stylesheet_link_tag(*names)
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

  def critical_css(params = {})
    scope = params.fetch(:scope, 'critical')
    name = find_scoped_css(scope)
    stylesheets = Array.wrap(params.fetch(:stylesheets, []))
    data = StringIO.new

    if name.blank?
      # insert stylesheets directly if not crit css
      data << '<!-- CRIT CSS NOT FOUND! -->'
      data << stylesheet_link_tag(*stylesheets) if stylesheets.present?
    else
      data << inline_css(name)
      data << css_preload(stylesheets) if stylesheets.present?
      data << inline_js('crit-utils/measure.js') if Rails.env.development?
    end

    data.string.html_safe
  end

  def smart_picture(object, *args, **xargs, &block)
    return '' if object.blank?

    IziLightup::SmartPicture.render(object, *args, **xargs, &block)
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
  rescue TypeError => _e
    false
  end
end
