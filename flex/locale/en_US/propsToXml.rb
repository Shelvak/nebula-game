margin = 80
puts "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>"
puts "<locale>"
Dir["*.properties"].sort.each do |fname|
  bundle = File.basename(fname, ".properties")
  c = File.read(fname)

  c = c.gsub("\\\n", "")
  c = c.split("\n")
  c = c.map do |line|
    if line.strip == ""
      nil
    else
      line.scan(/^(.+?)=(.+?)$/)[0]
    end
  end

  def wrap(sindent, s, indent, margin)
    cdata = cdata?(s)
    if ! cdata && sindent.length + s.length + 7 <= margin
      "#{sindent}<p>#{s}</p>"
    else
      wrapped = "#{sindent}<p>\n"
      wrapped += "#{indent}<![CDATA[\n" if cdata

      line = indent
      s.split(" ").each do |part|
        if line.length + part.length + 1 <= margin
          line += part + " "
        else
          wrapped += line + "\n"
          line = indent + part + " "
        end
      end
      wrapped += line + "\n"

      wrapped += "#{indent}]]>\n" if cdata
      wrapped += "#{sindent}</p>"

      wrapped
    end
  end

  def cdata?(value)
    value.include?("<") || value.include?("&")
  end

  puts "  <#{bundle}>"
  c.each do |entry|
    if entry.nil?
      puts
    else
      key, value = entry
      if (
        value.include?("\\n") || 
        key.length + value.length + 17 > margin ||
        cdata?(value)
      )
        puts "    <#{key}>"
        value.split("\\n").each do |p|
          if p != ""
            puts wrap("      ", p, "        ", margin)
          end
        end
        puts "    </#{key}>"
      else
        puts "    <#{key} value=\"#{value}\" />"
      end
    end
  end
  puts "  </#{bundle}>"
  puts
end
puts "</locale>"
