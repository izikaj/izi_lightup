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
    compile_asset(rails_app.config.assets.precompile)
  end

  private

  def assets_manifest
    @assets_manifest ||= find_or_build_assets_manifest
  end

  def find_or_build_assets_manifest
    return rails_app.assets_manifest if rails_app.respond_to?(:assets_manifest)
    return build_manifest(rails_app.assets) if rails_app.respond_to?(:assets)

    nil
  end

  def build_manifest(assets = [])
    Sprockets::Manifest.new(assets, assets_output_dir)
  end

  def assets_output_dir
    @assets_output_dir ||= Rails.root.join('public', rails_app.config.assets.prefix.presence || 'assets')
  end

  def rails_app
    Rails.application
  end
end
