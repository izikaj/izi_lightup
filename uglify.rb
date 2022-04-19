require 'uglifier'

%w[
  wait_for
  mini_require
  active_emit
].each do |name|
  raw = File.read("app/assets/javascripts/crit-utils/#{name}.js")
  minified = Uglifier.new.compile(raw)
  File.write("app/assets/javascripts/crit-utils/#{name}.min.js", minified)
  puts "#{name}: #{raw.size} >>> #{minified.size} (#{((raw.size - minified.size) * -100.0 / raw.size).round(2)}%)"
end
