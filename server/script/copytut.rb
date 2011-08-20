#!/usr/bin/env ruby

require 'rubygems'
require 'media_wiki'

def login
  puts "Logging in to source"
  mw1 = MediaWiki::Gateway.new("http://wiki.nebula44.com/api.php")
  mw1.login("arturaz", "")

  puts "Logging in to dest"
  mw2 = MediaWiki::Gateway.new("http://wiki.nebula44.lt/api.php")
  mw2.login("arturas", "")

  [mw1, mw2]
end


mw1, mw2 = login
processed = Set.new
pending = ARGV.dup

MAX_RETRIES = 2

puts "Processing..."
while pending.size > 0
  src = pending.shift
  unless processed.include?(src)
    retries_left = MAX_RETRIES
    begin
      puts "* Copying #{src} (#{pending.size} left)"
      content = mw1.get(src)
      next if content.nil?
      mw2.edit(src, content)

      content.scan(/\[\[(.+?)\]\]/).each do |matches|
        name = matches[0]
        if name =~ /^Category:/
          # Categories 
          next
        elsif name =~ /^File:/
          # Support for [[File:foo.png|frame]]
          file = name.split(":", 2)[1].split("|")[0]
          unless processed.include?(name)
            puts "  * Transfering #{file}."
            props = mw1.image_info(file, 'iiprop' => ['url'])
            raise "Not an image? #{name}" if props.nil?
            url = props['url']
            mw2.upload(nil, 'filename' => file, 'url' => url)

            processed.add name
          else
            puts "    Skipping transfered file #{file}."
          end
        else
          # Support for [[Foo|Bar baz]]
          name = name.split("|")[0]
          pending.push name
        end
      end

      processed.add(src)
    rescue MediaWiki::Exception => e
      if retries_left > 0
        retries_left -= 1
        puts "!! Failed, retrying! (#{retries_left} retries left)"
        mw1, mw2 = login
        retry
      else
        raise e
      end
    end
  else
    puts "  Skipping #{src}."
  end
end
puts "Done!"
