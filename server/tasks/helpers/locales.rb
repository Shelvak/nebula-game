require 'xmlsimple'

class LocaleChecker
  # Locale reference regular expression.
  REFERENCE_REGEXP = /\[reference:((\w+)\/)?(.+?)\]/
  # Locale object regular expression.
  # E.g.: [obj:1:Technology_Cyrix:what:dc]
  OBJECT_REGEXP = /\[obj:.+?:(.+?)(:(.*?)(:[a-z]+)?)?\]/

  def initialize(source_dir)
    @source_dir = source_dir
  end

  def locale_files
    Dir[File.join(@source_dir, "*.xml")]
  end

  def check
    @errors = {}
    @global_keyset = Set.new
    @keys = {}

    locale_files.each do |fpath|
      fname = File.basename(fpath)
      @keys[fname] = Set.new

      puts "Checking #{fname}"
      contents = XmlSimple.xml_in(fpath)
      contents.each do |bundle_name, bundle_contents|
        if bundle_contents.size > 1
          errors.push "More than one bundle with name #{bundle_name} found!"
        end

        bundle_contents[0].each do |key, values|
          unless bundle_name == "Objects" && key.match(/-\w+$/)
            full_key = "#{bundle_name}/#{key}"
            @global_keyset.add full_key
            @keys[fname].add full_key
          end

          value = nil
          if values[0].is_a?(String)
            # <message.allianceJoined>
            #   Player "{0}" has joined "{1}"
            # </message.allianceJoined>
            value = values[0]
          elsif values[0].has_key?('value')
            # <Key value="something" />
            value = values[0]['value']
          elsif values[0].has_key?('ref')
            # <Key ref="some_other_key" />
            value = "[reference:#{values[0]['ref']}]"
          else
            # <tooltip.buildInFlank2>
            #   <p>Your units will appear in second flank.</p>
            #   <p>[reference:tooltip.buildInFlankCommon]</p>
            # </tooltip.buildInFlank2>
            value = values[0]['p'].join("\n")
          end

          check_references(fname, contents, bundle_name, value)
          check_objects(fname, contents, value)
        end
      end
    end

    check_keys
  end

  def report
    if @errors.size > 0
      puts "Following errors detected:"
      @errors.each do |fname, error_hash|
        lines = File.read(File.join(@source_dir, fname)).split("\n")
        puts "  In #{fname}:"

        (error_hash[:references] || []).each do |full_refname, bundle, refname|
          needle = /\[reference:(#{bundle}\/)?#{refname}/
          lines = grep_lines_str(lines, refname)

          puts "    * Reference #{full_refname} is broken @ #{lines}."
        end

        (error_hash[:objects] || []).each do |object_name, object_key, noun|
          needle = /\[obj:.+?:#{object_key}:#{noun}/
          lines = grep_lines_str(lines, needle)

          puts "    * Object #{object_name} is broken @ #{lines}."
        end

        (error_hash[:missing_keys] || []).each do |missing_key|
          files = @keys.map do |key_fname, file_keys|
            file_keys.include?(missing_key) ? key_fname : nil
          end.compact.join(", ")
          puts "    * Missing key #{missing_key.inspect}. Defined in #{files}."
        end
      end
    else
      puts "Locales are ok."
    end
  end

  private
  def grep_lines(lines, needle)
    index = 0
    lines.map do |line|
      index += 1
      (needle.is_a?(String) && line.include?(needle)) ||
        (needle.is_a?(Regexp) && line.match(needle)) \
        ? index : nil
    end.compact
  end

  def grep_lines_str(lines, needle)
    line_numbers = grep_lines(lines, needle)
    case line_numbers.size
    when 0 then "unknown line"
    when 1 then "line #{line_numbers[0]}"
    else "lines #{line_numbers.join(", ")}"
    end
  end

  def check_references(fname, contents, current_bundle, value)
    value.scan(REFERENCE_REGEXP) do |unused, bundle, name|
      bundle = current_bundle if bundle.nil?

      if ! contents[bundle][0].has_key?(name)
        ref_name = bundle.nil? ? name : "#{bundle}/#{name}"

        @errors[fname] ||= {}
        @errors[fname][:references] ||= Set.new
        @errors[fname][:references].add [ref_name, bundle, name]
      end
    end
  end

  def check_objects(fname, contents, value)
    value.scan(OBJECT_REGEXP) do |object_key, _, noun, *_|
      unless object_key.match(/^\{\d+\}$/)
        name = object_key
        name += "-#{noun}" unless noun.nil? || noun == ""

        if ! contents["Objects"][0].has_key?(name)
          @errors[fname] ||= {}
          @errors[fname][:objects] ||= Set.new
          @errors[fname][:objects].add [name, object_key, noun]
        end
      end
    end
  end

  def check_keys
    @keys.each do |fname, file_keys|
      missing_keys = (@global_keyset - file_keys)
      unless missing_keys.size == 0
        @errors[fname] ||= {}
        @errors[fname][:missing_keys] = missing_keys
      end
    end
  end
end