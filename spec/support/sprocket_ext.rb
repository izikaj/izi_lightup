# frozen_string_literal: true

module SprocketExt
  def compile_asset(name)
    Rails.application&.assets_manifest&.compile(name)
  end

  def clean_all_assets!
    FileUtils.rm_rf(Rails.root.join('public', Rails.application.config.assets.prefix.presence || 'assets'))
    Rails.application&.assets_manifest&.clean
  end

  def compile_all_assets!
    compile_asset(Rails.application.config.assets.precompile)
  end
end
