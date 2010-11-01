require 'fileutils'

Dir["**/*.scala"].each do |file|
  puts file
  pkg = File.dirname(file).gsub('/', '.')
  c = File.read(file)
  c = c.sub(/^package .+$/, "package #{pkg}")
  File.open(file, "w") { |f| f.write c }
end
