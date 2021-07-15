# frozen_string_literal: true

# extend mime types if need
Mime::Type.register_alias('image/svg+xml', :svg) unless defined?(Mime::SVG)
