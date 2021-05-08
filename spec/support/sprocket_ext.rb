# frozen_string_literal: true

module SprocketExt
  def compile_asset(name)
    return unless assets_manifest.respond_to?(:compile)

    Array.wrap(name).each do |item|
      begin
        assets_manifest.compile(item)
      rescue TypeError => _e
        # skip type errors
      end
    end
  end

  def clean_all_assets!
    FileUtils.rm_rf(assets_output_dir)
    assets_manifest.clean if assets_manifest.respond_to?(:clean)
  end

  def compile_all_assets!
    compile_asset(Rails.application.config.assets.precompile)
  end

  private

  def assets_manifest
    @assets_manifest ||= find_or_build_assets_manifest
  end

  def find_or_build_assets_manifest
    app = Rails.application

    return app.assets_manifest if app.respond_to?(:assets_manifest)
    return build_manifest(app.assets) if app.respond_to?(:assets)
  end

  def build_manifest(assets = [])
    Sprockets::Manifest.new(assets, assets_output_dir)
  end

  def assets_output_dir
    @assets_output_dir ||= Rails.root.join('public', Rails.application.config.assets.prefix.presence || 'assets')
  end
end
