#!/usr/bin/env ruby
lines = File.read("permissions").split("\n")
lines.each_with_index do |line, index|
  $stdout.write "\r#{index + 1}/#{lines.size}"
  parts = line.split(" ")
  permissions = parts.pop.to_i(8)
  user, group = parts.pop.split(":").map { |s| s.to_i }
  file = ".#{parts.join(" ")}"
  if File.exists?(file)
    File.chown(user, group, file)
    File.chmod(permissions, file)
  end
end
puts "\nDone."
