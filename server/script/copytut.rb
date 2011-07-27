#!/usr/bin/env ruby

require 'media_wiki'
mw1 = MediaWiki::Gateway.new("http://wiki-dev.nebula44.com/api.php")
mw1.login("wiki_access", "ngweb3234-323.3")

mw2 = MediaWiki::Gateway.new("http://wiki.nebula44.com/api.php")
mw2.login("arturaz", "my_pass")

ARGV.each do |src|
  src = src.split("/")[-1]
  content = mw1.get(src)
  mw2.edit(src, content)
  content.scan(/\[\[File:(.+?)\]\]/).each do |matches|
    file = matches[0]
    props = mw1.image_info(file, 'iiprop' => ['url'])
    url = props['url']
    mw2.upload(nil, 'filename' => file, 'url' => url)
    puts "Transfered #{file}."
  end
  puts "Copied #{src}."
end
