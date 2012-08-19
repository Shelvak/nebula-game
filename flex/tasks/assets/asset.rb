require 'java'

class Tasks::Assets::Asset
  SWF_RE = /\.swf$/i
  PNG_RE = /\.png$/i
  JPG_RE = /\.jpe?g$/i
  MP3_RE = /\.mp(eg)?3$/i

  def self.swf?(path); !! path.match(SWF_RE); end
  def self.image?(path); png?(path) || jpg?(path); end
  def self.png?(path); !! path.match(PNG_RE); end
  def self.jpg?(path); !! path.match(JPG_RE); end
  def self.mp3?(path); !! path.match(MP3_RE); end
  def self.type(path)
    if swf?(path) then :swf
    elsif png?(path) then :png
    elsif jpg?(path) then :jpg
    elsif mp3?(path) then :mp3
    else :other
    end
  end

  def self.mime_type(path)
    case type(path)
    when :swf then "application/octet-stream"
    when :mp3 then "audio/mpeg"
    when :jpg then "image/jpeg"
    when :png then "image/png"
    else raise "Cannot determine mime type for '#{path}'!"
    end
  end

  def self.commit_time(path)
    commit_times([path]).first
  end

  # Returns commit timestamps for _paths_.
  #
  # Fast version for determining multiple timestamps. Order can be random.
  def self.commit_times(paths)
    grouped = paths.inject({}) do |hash, path|
      dirname = File.dirname(path)
      basename = File.basename(path)

      hash[dirname] ||= []
      hash[dirname] << [path, basename]
      hash
    end

    timestamps = []

    grouped.each do |dir, names|
      cmd = ["cd #{dir.inspect}"]
      names.each do |path, basename|
        cmd << "git log --format='%ct' -1 -- #{basename.inspect}"
      end
      cmd = cmd.join(" && ")

      `#{cmd}`.split("\n").each_with_index do |line, index|
        timestamp = line.strip.to_i
        path = names[index][0]
        raise "Cannot determine commit time for #{path}!" if timestamp == 0
        timestamps << timestamp
      end
    end

    raise "Wanted to get #{paths.size} timestamps, but only got #{
      timestamps.size} timestamps instead!" if paths.size != timestamps.size

    timestamps
  end

  # Sets time modification time. _timestamp_ must be given in seconds.
  def self.set_mtime(path, timestamp)
    file = java.io.File.new(path)
    raise "Cannot set mtime of #{path} to #{timestamp}!" \
      unless file.set_last_modified(timestamp * 1000)
  end
end