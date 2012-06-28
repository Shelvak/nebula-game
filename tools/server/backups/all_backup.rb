#!/usr/bin/env ruby
PROCESS_NAME = "all_backup_ruby"

require 'time'

ENV["LC_ALL"] = "C"
BACKUPS = '/var/backups'
FS_DIR = "#{BACKUPS}/filesystem"
SSH="ssh"
HOST="backup@thor.nebula44.com"
RDIR=`hostname -f`.chomp

def running?
  `ps auxf | grep "#{PROCESS_NAME}" | grep -v grep` != ""
end

exit 0 if running?
$0 = PROCESS_NAME

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

target="#{HOST}:#{RDIR}"

puts "Ensuring mysql dir exists in remote."
run %Q{#{SSH} #{HOST} "mkdir -p #{RDIR}/mysql"}
puts "Transferring mysql to remote..."
run %Q{rsync -a --delete -e "#{SSH}" #{BACKUPS}/mysql/ #{target}/mysql/}

backups = Dir["#{FS_DIR}/*"].map do |path|
  date, time = File.basename(path).split("-")
  date.gsub!("_", "-")
  time.gsub!("_", ":")
  time = Time.parse("#{date} #{time}")

  {:path => path, :time => time}
end.sort_by { |b| b[:time] }
last = backups[-1][:path].sub(/\/$/, '')
last_basename = File.basename(last)

puts "Ensuring filesystem dir exists in remote."
run %Q{#{SSH} #{HOST} "mkdir -p #{RDIR}/filesystem"}
puts "Listing remote filesystem backups..."
last_remote = `#{SSH} #{HOST} "ls -1 #{RDIR}/filesystem"`
last_remote = last_remote.strip == "" \
  ? nil : last_remote.split.reverse.find { |r| r != last_basename }

puts "Transfering filesystem to remote..."
run %Q{rsync -a -e "#{SSH}" #{last} #{target}/filesystem/}
unless last_remote.nil?
  puts "Hardlinking filesystem to previous backup in remote..."
  remote = "#{RDIR}/filesystem/#{last_basename}"
  remote_ul = "#{remote}-unlinked"
  run %Q{#{SSH} #{HOST} "mv '#{remote}' '#{remote_ul}' && \
    rsync -a '--link-dest=../#{last_remote}' '#{remote_ul}/' '#{remote}/' && \
    rm -rf '#{remote_ul}'"}
end

puts "Removing temp files..."
%w{stderr stdout}.each do |f|
  File.unlink(f) if File.exists?(f)
end

puts "Done!"
