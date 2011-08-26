#!/usr/bin/env ruby

# This script is used to sync backups from potentially unsafe
# location (where backups user can remove things) to root
# owned location by hardlinking.

require 'time'
require 'fileutils'

# How long we should keep our backups for?
KEEP_FOR = 6 * 7 * 24 * 3600 # 6 weeks

BASE = '/var/backups'
SRC = "#{BASE}/*/{mysql,filesystem}"
SAFE = '/var/backups-safe'
CHECKPOINTS = 'xtrabackup_checkpoints'

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

File.umask(0077)

puts "Syncing backups to safe location..."
Dir[SRC].each do |dir|
  dir.sub! /\/$/, ''
  short = dir.sub "#{BASE}/", ""
  dest = "#{SAFE}/#{short}"
  FileUtils.mkdir_p dest
  run "rsync -a --link-dest=#{dir}/ #{dir}/ #{dest}"
end

[BASE, SAFE].each do |base|
  puts "Cleaning up old mysql backups in #{base}"

  backups = Dir["#{base}/*/mysql/*"].map do |path|
    date, time = File.basename(path).split("-")
    date.gsub!("_", "-")
    time.gsub!("_", ":")
    time = Time.parse("#{date} #{time}")

    is_incremental = File.read(
      File.join(path, CHECKPOINTS)
    ).include?("backup_type = incremental")

    {:path => path, :time => time, :incremental => is_incremental}
  end.sort_by { |b| b[:time] }

  backups.each do |b|
    if ! b[:incremental] && Time.now - b[:time] <= KEEP_FOR
      # Finish with the loop, nothing more to remove because
      # all later backups will be newer.
      break
    end

    puts "Removing #{b[:path]} (incremental: #{b[:incremental]})."
    FileUtils.rm_rf b[:path]
  end

  puts "Cleaning up old filesystem backups in #{base}"
  backups = Dir["#{base}/*/filesystem/*"].map do |path|
    date, time = File.basename(path).split("-")
    date.gsub!("_", "-")
    time.gsub!("_", ":")
    time = Time.parse("#{date} #{time}")

    {:path => path, :time => time}
  end.sort_by { |b| b[:time] }

  backups.each do |b|
    if Time.now - b[:time] <= KEEP_FOR
      # Finish with the loop, nothing more to remove because
      # all later backups will be newer.
      break
    end

    puts "Removing #{b[:path]}."
    FileUtils.rm_rf b[:path]
  end
end
