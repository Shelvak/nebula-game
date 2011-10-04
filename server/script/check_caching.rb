#!/usr/bin/env ruby

if ARGV[0].nil?
  puts %Q{Usage: #{$0} host}
  exit
end

require 'set'
require 'net/http'
STDOUT.sync = true
base = ARGV[0]

Net::HTTP.start(base, 80) do |http|
  %w{index.html assets/checksums locale/checksums}.each do |f|
    url = "#{base}/#{f}"
    STDOUT.write "#{url} ... "
    response = http.head("/#{f}")
    if response["Cache-Control"] == "no-cache"
      puts "uncached. OK."
    else
      puts "Cached! FAIL!"
    end
  end

  cached_files = Set.new

  index = http.get("/index.html").body
  swf = index.match(/swf: "(.+?)"/)[1]
  swf_checksum = index.match(/swfChecksum: "(.+?)"/)[1]
  cached_files.add "#{swf}-#{swf_checksum}.swf"
  game_js = index.match(/var gameJs = .+ : "(.+?)";/)[1]
  cached_files.add game_js

  %w{assets/checksums locale/checksums}.each do |f|
    file_base = f.split("/")[0]
    checksums = http.get("/" + f).body
    checksums.split("\n").each do |line|
      cached_files.add "#{file_base}/#{line.split()[1]}"
    end
  end

  time_str = "max-age=31536000"
  cached_files.each do |f|
    STDOUT.write "#{f} ... "
    headers = http.head("/#{f}")
    cc = headers["Cache-Control"]
    if cc
      if cc.include?(time_str)
        puts "cached. OK."
      else
        puts "cached, but wrong time. Expected #{time_str}, but was #{cc}."
      end
    else
      puts "Uncached. FAIL!"
    end
  end
end