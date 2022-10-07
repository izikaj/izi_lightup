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

  def critical_js(bundle: 'crit-utils/bundle.js')
    inline_js(bundle).presence || inline_js('crit-utils/bundle.js').presence ||
      '<!-- CRIT JS NOT FOUND! -->'.html_safe
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
      if stylesheets.present?
        preload_css = css_preload(stylesheets)
        if block_given?
          yield preload_css
        else
          data << preload_css
        end
      end
      data << inline_js('crit-utils/measure.js') if Rails.env.development?
    end

    data.string.html_safe
  end

  def smart_picture(object, *args, **xargs, &block)
    return '' if object.blank?

    IziLightup::SmartPicture.render(object, *args, **xargs, &block)
  end

  def debug_critical_css(scope_name = 'critical')
    {
      lookup: names_for_critical_lookup(scope_name),
      found: find_scoped_css(scope_name)
    }.to_json.html_safe
  end

  def names_for_critical_lookup(scope_name = 'critical', extname = '.css')
    names = [
      [controller_path, action_name].compact.join('_'),
      controller_path,
      *scoped_namespace_file,
      [controller_name, action_name].compact.join('_'),
      controller_name,
    ].reject(&:blank?).uniq
    names << nil

    names.map { |l| "#{File.join([scope_name, l].compact)}#{extname}" }
  end

  private

  def scoped_namespace_file(_scope_name = nil)
    scopes = []
    return scopes if controller_path == controller_name

    parts = controller_path.gsub(/\/#{controller_name}$/, '').split('/').reject(&:blank?)
    parts.each { |p| scopes.unshift(File.join([scopes.first, p].compact)) }

    scopes.uniq
  end

  def find_scoped_css(scope_name)
    names_for_critical_lookup(scope_name).detect { |n| asset_exist?(n) }
  end

  def fetch_items(object, fields)
    Array.wrap(fields).map do |name|
      object.respond_to?(name) ? object.public_send(name) : nil
    end.compact
  end

  def asset_exist?(name)
    return find_asset_source(name)&.present? if compile_assets?

    manifest.assets.key?(name) || has_digest_version?(name) rescue false
  end

  def has_digest_version?(name)
    return unless Rails.application.config.respond_to?(:assets)
    return unless Rails.application.config.assets.respond_to?(:digests)

    Rails.application.config.assets.digests.key?(name)
  end

  def compile_assets?
    Rails.application.config.assets.compile
  end

  def find_asset_source(name)
    return find_sources_fallback(name) if old_manifest?

    manifest.find_sources(name)&.first
  end

  def find_sources_fallback(asset_path)
    Rails.application.assets.find_asset(asset_path) if Rails.application.assets
  end

  def old_manifest?
    !manifest.respond_to?(:find_sources)
  end

  def manifest
    @manifest ||= find_or_build_assets_manifest
  end

  def find_or_build_assets_manifest
    app = Rails.application

    return app.assets_manifest if app.respond_to?(:assets_manifest)
    return build_manifest(app.assets) if app.respond_to?(:assets)
  end

  def build_manifest(assets = [])
    ::Sprockets::Manifest.new(assets, assets_output_dir)
  end

  def assets_output_dir
    @assets_output_dir ||= Rails.root.join('public', Rails.application.config.assets.prefix.presence&.gsub(/^\//, '') || 'assets')
  end
end
