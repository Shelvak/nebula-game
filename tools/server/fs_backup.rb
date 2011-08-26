#!/usr/bin/env ruby

require 'time'
require 'fileutils'

# How long we should keep our backups for?
KEEP_FOR = 4 * 7 * 24 * 3600 # 4 weeks
FS_DIR = '/var/backups/filesystem'
now = Time.now.strftime("%Y_%m_%d-%H_%M_%S")

File.umask(0077)

now_dir = File.expand_path(File.join(FS_DIR, now))

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

backups = Dir["#{FS_DIR}/*"].map do |path|
  date, time = File.basename(path).split("-")
  date.gsub!("_", "-")
  time.gsub!("_", ":")
  time = Time.parse("#{date} #{time}")

  {:path => path, :time => time}
end.sort_by { |b| b[:time] }

puts "Cleaning up old backups."
backups.dup.each do |b|
  if Time.now - b[:time] <= KEEP_FOR
    # Finish with the loop, nothing more to remove because
    # all later backups will be newer.
    break
  end

  puts "Removing #{b[:path]}."
  FileUtils.rm_rf b[:path]
  # Remove backup from backups list.
  backups.shift
end

FileUtils.mkdir_p(now_dir) unless File.exists?(now_dir)
home = "/home/spacegame"
%W{
  /etc #{home}/web/shared/forum #{home}/web/shared/wiki 
  #{home}/web/shared/web/system #{home}/config
}.each do |dir|
  dir = dir.sub(/\/$/, '')
  target_dir = now_dir + dir
  opts = backups.size == 0 \
    ? "" : "--link-dest=#{backups[-1][:path]}#{dir}"

  FileUtils.mkdir_p(target_dir) unless File.exists?(target_dir)
  run("rsync -a --delete #{opts} #{dir}/ #{target_dir}")
  File.open("#{now_dir}/permissions", "a") do |f|
    `find #{dir}`.split("\n").each do |fpath|
      begin
        stat = File.stat(fpath)
        f.write("%s %d:%d %o\n" % [fpath, stat.uid, stat.gid, stat.mode])
      rescue Errno::ENOENT
      end
    end
  end
end
