#!/usr/bin/env ruby
require 'time'

ENV["LC_ALL"] = "C"
BACKUPS = '/var/backups'
FS_DIR = "#{BACKUPS}/filesystem"

def run(cmd)
  puts "Running '#{cmd}'..."
  status = system cmd
  unless $?.success?
    puts
    puts "Running `#{cmd}` failed with exit status #{$?.exitstatus}!"
    exit 1
  end
  status
end

pwd = File.expand_path(File.dirname(__FILE__))

puts "Backuping mysql..."
run "#{pwd}/mysql_backup.rb"
puts "Backuping filesystem..."
run "#{pwd}/fs_backup.rb"

ssh="ssh -i /root/.ssh/backups_rsa -p 20022"
host="backup@wh.down.lt"
rdir="demosis.nebula44.lt"
target="#{host}:#{rdir}"

puts "Transferring mysql to remote..."
run %Q{rsync -a --delete -e "#{ssh}" #{BACKUPS}/mysql/ #{target}/mysql/}

backups = Dir["#{FS_DIR}/*"].map do |path|
  date, time = File.basename(path).split("-")
  date.gsub!("_", "-")
  time.gsub!("_", ":")
  time = Time.parse("#{date} #{time}")

  {:path => path, :time => time}
end.sort_by { |b| b[:time] }
last = backups[-1][:path].sub(/\/$/, '')

puts "Listing remote filesystem backups..."
last_remote = `#{ssh} #{host} "ls -1 #{rdir}/filesystem"`
if last_remote.strip == ""
  last_remote = ""
else
  last_remote = %Q{"--link-dest=#{last_remote.split[-1]}"}
end
puts "Transfering filesystem to remote..."
run %Q{rsync -a -e "#{ssh}" #{last_remote} #{last} #{target}/filesystem/}

puts "Removing temp files..."
%w{stderr stdout}.each do |f|
  File.unlink(f) if File.exists?(f)
end

puts "Done!"
