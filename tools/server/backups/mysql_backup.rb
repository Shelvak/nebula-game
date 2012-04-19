#!/usr/bin/env ruby
require 'time'
require 'fileutils'

# How often full backup should be done?
FULL_EVERY = 1 * 7 * 24 * 3600 # 1 week
# How long should full backups be kept?
# Removing full backup removes all incremental backups 
# until next full backup.
KEEP_FOR = 4 * 7 * 24 * 3600 # 4 weeks
MYSQL_DIR = '/var/backups/mysql'
BINARY = 'xtrabackup_binary'
CHECKPOINTS = 'xtrabackup_checkpoints'
now = Time.now.strftime("%Y_%m_%d-%H_%M_%S")

File.umask(0077)

now_dir = File.expand_path(File.join(MYSQL_DIR, now))

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

backup_opts = "--defaults-file=/etc/mysql/debian.cnf"
backups = Dir["#{MYSQL_DIR}/*"].map do |path|
  date, time = File.basename(path).split("-")
  date.gsub!("_", "-")
  time.gsub!("_", ":")
  time = Time.parse("#{date} #{time}")

  is_incremental = File.read(
    File.join(path, CHECKPOINTS)
  ).include?("backup_type = incremental")

  {:path => path, :time => time, :incremental => is_incremental}
end.sort_by { |b| b[:time] }

puts "Cleaning up old backups."
backups.dup.each do |b|
  if ! b[:incremental] && Time.now - b[:time] <= KEEP_FOR
    # Finish with the loop, nothing more to remove because
    # all later backups will be newer.
    break
  end

  puts "Removing #{b[:path]}."
  FileUtils.rm_rf b[:path]
  # Remove backup from backups list.
  backups.shift
end

target = File.join(now_dir, "backup.tar.gz")

full_backup = backups.find do |b| 
  ! b[:incremental] && Time.now - b[:time] < FULL_EVERY
end

if full_backup.nil?
  puts "No recent full backup, doing full backup."
  Dir.mkdir(now_dir)

  backup_opts += " --stream=tar"
  run("innobackupex #{backup_opts} #{now_dir} | gzip - > #{target}")
  puts "Extracting checkpoints file."
  run("tar -C #{now_dir} -ixzf #{target} #{CHECKPOINTS}")
else
  puts "Found full backup done in #{full_backup[:path]}"
  puts "Doing incremental backup."

  last = backups[-1]
  checkpoints = File.join(last[:path], CHECKPOINTS)
  match = File.read(checkpoints).match(/^to_lsn = (\d+)$/)
  if match.nil?
    puts "Cannot read 'to_lsn' from #{checkpoints.inspect}!"
    exit 2
  end

  lsn = match[1]
  backup_opts += " --incremental --incremental-lsn=#{lsn}"
  backup_opts += " --no-timestamp"
  run("innobackupex #{backup_opts} #{now_dir}")

  puts "Archiving."
  archive_dir = File.join(now_dir, "archive")
  files = Dir["#{now_dir}/*"] - [
    File.join(now_dir, CHECKPOINTS),
    File.join(now_dir, BINARY)
  ]
  Dir.mkdir(archive_dir)
  files.each { |file| FileUtils.mv(file, archive_dir) }
  run("tar -C #{archive_dir} -czif #{target} .")
  FileUtils.rm_rf archive_dir
end

puts "Done."

