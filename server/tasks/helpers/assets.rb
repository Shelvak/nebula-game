require 'timeout'
require 'digest'
require 'pp'

ZIP_RE = /\.zip$/i
ZIP_BUNDLE_FILE_EXTENSIONS = "jpg,jpeg,png"
PNG_RE = /\.png$/i
JPG_RE = /\.jpe?g$/i

class BadExitStatusError < StandardError
  def initialize(cmd, status)
    @status = status
    super("Bad exit status for #{cmd.inspect}: #{status.exitstatus}")
  end
end

class Assets
  PROJECT_BASE_DIR = File.expand_path(
    # ROOT_DIR is not yet defined here
    File.join(File.dirname(__FILE__), '..', '..', '..')
  )
  ASSET_DIR = File.join(PROJECT_BASE_DIR, 'assets')
  CONFIG_DIR = File.join(ASSET_DIR, 'config')
  FileUtils.mkdir_p CONFIG_DIR
  
  HASHES_DIR = File.join(ASSET_DIR, 'current')
  FileUtils.mkdir_p HASHES_DIR
  DOWNLOADED_FILE_HASHES = File.join(HASHES_DIR,
    'downloaded_asset_hashes.txt')
  MISSING_HASH = nil

  def self.store_hashes(destination, hashes=nil)
    hashes ||= WikiMechanize.instance.asset_hashes
    File.open(destination, "wb") do |file|
      file.write hashes.to_a.sort.to_yaml
    end
  end

  def self.load_hashes(source)
    if File.exists?(source)
      Hash[ *YAML.load(File.read(source)).flatten ]
    else
      {}
    end
  end

  # Return hash of one asset or +Hash+ of hashes if directory is given.
  def self.hash(asset_or_dir)
    if File.directory?(asset_or_dir)
      hashes = {}
      Dir["#{asset_or_dir}/**/*"].each do |asset|
        relative_path = asset.sub("#{asset_or_dir}/", "")
        hashes[relative_path] = hash(asset) unless File.directory?(asset)
      end
      hashes
    else
      File.exist?(asset_or_dir) \
          ? Digest::SHA1.hexdigest(
            File.open(asset_or_dir, 'rb') { |file| file.read }
          ) \
          : MISSING_HASH
    end
  end
end

class FilesBundle < Hash
  attr_reader :dir, :name, :opts

  def initialize(dir, entries={}, opts={})
    @dir = dir
    @name = "%sBundle" % dir.gsub("/", "_").camelcase
    @opts = opts
    merge!(entries)
  end

  def <=>(bundle)
    self.name <=> bundle.name
  end

  def each
    keys.sort.each do |local|
      yield local, self[local][:name], self[local]
    end
  end
end

class Asset
  def self.image?(path); png?(path) or jpg?(path); end
  def self.zip?(path); path.match(ZIP_RE); end
  def self.png?(path); path.match(PNG_RE); end
  def self.jpg?(path); path.match(JPG_RE); end
  def self.type(path)
    if png?(path)
      :png
    elsif jpg?(path)
      :jpg
    elsif zip?(path)
      :zip
    else
      :other
    end
  end
end

# Class that holds information about assets.
class AssetBase
  ALLOWED_OPTIONS = {
    # Zips can have anything inside.
    :zip => %w{combine pp_opts path_change quantize_speed
      optimize_png_level optimize_jpg_quality},
    :png => %w{pp_opts path_change quantize_speed optimize_png_level
      save_as},
    :jpg => %w{pp_opts path_change optimize_jpg_quality save_as}
  }

  def initialize
    template = ERB.new(File.read(File.join(
          Assets::PROJECT_BASE_DIR, 'assets', 'assets.yml')))
    processed = template.result(binding)
    @data = YAML.load(processed)
    process_file_options
    build_lists
  end

  # Number of remote files.
  def remote_count
    @remote_count
  end

  # Yields +FilesBundle+ objects.
  def each_bundle(&block)
    @bundles.each(&block)
  end

  # Yields _remote_name_, _local_name_, _info_.
  def each
    @remote_files.each do |name, infos|
      infos.each do |info|
        yield name, info[:name], info
      end
    end
  end

  # Decodes _target_ and yields _target_name_ and _target_path_.
  #
  # "*" yields all targets.
  #
  def decode_target(target, &block)
    if target == "*"
      @data['targets'].keys.each do |t|
        decode_target(t, &block)
      end
    else
      yield target, File.join(
        Assets::PROJECT_BASE_DIR, @data['targets'][target]['path']
      ) unless @data['targets'][target]['disabled']
    end
  end

  # Returns target options for _remote_ file as +String+.
  def opts_string(remote)
    infos = @remote_files[remote]
    type = Asset.type(remote)
    all_opts = []
    infos.each do |info|
      part_opts = {}
      decode_target(info[:target]) do |target, target_dir|
        merge_opts(target, info).each do |key, value|
          if ALLOWED_OPTIONS[type].include?(key)
            part_opts[target] ||= {}
            part_opts[target][key] = value
          end
        end
      end
      all_opts.push part_opts
    end

    all_opts.inspect
  end

  # Merge given options with _target_ specific options.
  def merge_opts(target, info_hash)
    @data['options'].merge(
      @data['targets'][target]
    ).merge(
      info_hash[:bundle].opts["*"] || {}
    ).merge(
      info_hash[:bundle].opts[target] || {}
    ).merge(
      info_hash[:opts]["*"] || {}
    ).merge(
      info_hash[:opts][target] || {}
    )
  end

  private
  def file_opts(name)
    options = {}
    @data['file_options'].each do |target, regexps|
      regexps.each do |regexp, opts|
        if name.match(regexp)
          # One file may match more than one regexp.
          options[target] ||= {}
          options[target].merge!(opts)
        end
      end
    end

    options
  end

  def process_file_options
    @data['file_options'].each do |target, file_options|
      file_options.each do |regexp_string, options|
        @data['file_options'][target].delete(regexp_string)
        @data['file_options'][target][Regexp.new(regexp_string)] = options
      end
    end
  end

  def build_lists
    @bundles = []
    @remote_files = {}
    @remote_count = 0
    @data['assets'].each do |bundle_dir, targets|
      bundle = FilesBundle.new(bundle_dir, {}, targets['opts'] || {})
      targets.except('opts').each do |target, dirs|
        dirs.each do |local_dir, files|
          files.each do |local, remote|
            local.strip!
            
            opts = nil

            case remote
            when String
              remote_name = remote.strip
              opts = file_opts(remote_name)
            when Hash
              remote_name = remote['wiki_name'].try(:strip)
              raise "wiki_name must be defined to local file #{
                local.inspect}: #{remote.inspect}" if remote_name.nil?
                
              opts = file_opts(remote_name).merge(
                remote.except('wiki_name')
              )
            else
              raise "Unknown remote entry for local file #{
                local_dir.inspect}: #{remote.inspect}"
            end

            path_dirs = [bundle_dir, local_dir, local].map(
              &:to_s
            ).reject { |e| e == "." }

            # Some local files may point to same remote file.
            @remote_files[remote_name] ||= []
            @remote_files[remote_name].push(
              :name => File.join(*path_dirs),
              :target => target,
              :opts => opts,
              :bundle => bundle
            )
            @remote_count += 1
            
            local_without_bundle = File.join(*path_dirs[1..-1])
            bundle[local_without_bundle] = {
              :name => remote_name,
              :target => target,
              :opts => opts
            }
          end
        end
      end

      @bundles.push bundle
    end
  end

  def each_model(type)
    Dir[
      File.join(ROOT_DIR, 'lib', 'app', 'models', type, '*.rb')
    ].each do |filename|
      basename = File.basename(filename, '.rb')
      yield basename.camelcase
    end
  end
end

# Processes given files for appropriate targets.
class Processor
  # _base_ is an +AssetBase+ object.
  def initialize(base)
    @base = base
  end

  # Process a +File+.
  def process(file, name, info_hash)
    target = info_hash[:target]

    if Asset.zip?(name)
      extract(file, name, info_hash)
      @base.decode_target(target) do |t, target_path|
        target_opts = @base.merge_opts(t, info_hash)
        combine(t, target_path, name, target_opts)
      end
    else
      @base.decode_target(target) do |t, target_path|
        target_opts = @base.merge_opts(t, info_hash)

        # Copy file from temp path to destination path
        name = process_name(name, target_opts)
        dest_file_path = File.join(target_path, name)

        info %Q{#{name} (#{t}): }
        FileUtils.mkdir_p(File.dirname(dest_file_path))
        FileUtils.cp(file.path, dest_file_path)

        preprocess(dest_file_path, target_opts)
        optimize(dest_file_path, target_opts)
        postprocess(dest_file_path, target_opts)
        info ".\n"
      end
    end
  end

  private
  def system(*args)
    status = Kernel.system(*args)
    raise BadExitStatusError.new(args.join(" "), $?) \
      unless $?.exitstatus == 0
    status
  end

  # Output info string.
  def info(string)
    $stdout.write(string)
    $stdout.flush
  end

  # Returns processed filename.
  def process_name(name, opts)
    name = name.gsub(opts['path_change']['from'], opts['path_change']['to']) \
      unless opts['path_change'].blank?
    name
  end
  
  def convert(path, options)
    target_convert = "%s%s" % [path, ".converted"]
      
    cmd = %Q{convert "%s" %s "%s"} % [path, options, target_convert]

    system(cmd)
    FileUtils.mv target_convert, path, :force => true
  end
  
  # Ensure we have a format that png2swf understands
  def convert_for_png2swf(path)
    convert(path, "-type TrueColorMatte -depth 8")
  end

  # Preprocess image before optimization
  def preprocess(path, opts)    
    if Asset.image?(path) and not opts['pp_opts'].blank?
      info "P(IMAGE) "
      convert(path, opts['pp_opts'])
    end
  end

  # Optimizes given image
  def optimize(path, opts)
    if Asset.png?(path)
      if opts['quantize_speed'] > 0
        quantized_ext = ".quantized.png"
        cmd = %Q{pngnq -s %s -n 256 -f -e "%s" "%s"} % [
          opts['quantize_speed'], quantized_ext, path
        ]
        quantized_target = path.sub(/\.png$/, quantized_ext)

        info "Q"
        system(cmd)

        FileUtils.mv quantized_target, path, :force => true
      end

      if opts['optimize_png_level'] > 0
        cmd = %Q{optipng -o %s -quiet "%s"} % [
          opts['optimize_png_level'], path
        ]

        info "O"
        system(cmd)
      end
    elsif Asset.jpg?(path)
      if opts['optimize_jpg_quality'] > 0
        info "O"
        convert(path, "-quality %s" % opts['optimize_jpg_quality'])
      end
    end
  end

  PNG2SWF = "png2swf -r 20 -z -j %d -T 10 -o %s %s"
  JPEG2SWF = "jpeg2swf -r 10 -z --quality %d -T 10 --output %s %s"

  # Postprocess asset after optimization
  def postprocess(path, opts)
    unless opts['save_as'].blank?
      type, params = opts['save_as'].split(":")
      
      case type
      when 'swf'
        quality, = params

        cmd = nil
        if Asset.png?(path)
          convert_for_png2swf(path)          
          cmd = PNG2SWF % [quality, "\"#{path.sub(PNG_RE, '.swf')}\"",
            "\"#{path}\""]
        elsif Asset.jpg?(path)
          cmd = JPEG2SWF % [quality, "\"#{path.sub(JPG_RE, '.swf')}\"",
            "\"#{path}\""]
        end

        if cmd
          info "->SWF(#{quality}%)"
          system(cmd)
          FileUtils.rm_f path
        end
      end
    end
  end

  def extract(file, name, info_hash)
    # Require zipruby here, because it' may not be installed when loading
    # rake tasks.
    require 'zipruby'

    dir_name = name.sub(ZIP_RE, '')

    puts "Unpacking ZIP: #{name}"
    Zip::Archive.open(file.path) do |archive|
      n = archive.num_files # number of entries

      n.times do |i|
        # open entry
        archive.fopen(i) do |f|
          zip_file_name = f.name

          # Skip directories.
          unless f.directory?
            # Ignore all paths
            zip_file_name = File.basename(zip_file_name)

            # Metadata goes somewhere else.
            if zip_file_name == 'metadata.yml'
              parts = name.split("/")
              base = parts[0..-2]
              model_name = File.basename(parts[-1], ".*")
              part_name = (
                ['assets'] + base + [model_name]
              ).map(&:underscore)

              zip_file_dest = File.join(
                Assets::CONFIG_DIR, "%s.yml" % part_name.join(".")
              )
              File.open(zip_file_dest, 'wb') { |out| out.write f.read }
            else
              tempfile = Tempfile.new('wiki-zip')
              File.open(tempfile.path, 'wb') { |out| out.write f.read }
              process(tempfile, File.join(dir_name, zip_file_name),
                info_hash)
            end
          end
        end
      end
    end
  end

  def combine(target, target_path, name, opts)
    return if opts['combine'].blank?

    method, params = opts['combine'].split(":")

    case method
    when 'swf'
      quality, = params

      base_name = name.sub(ZIP_RE, '')
      base_dir = File.join(target_path, base_name)
      swf_name = "#{base_dir}.swf"
      
      puts "#{base_name}/*.png (#{target}): combining to SWF (#{
        quality}% JPEG)."
      
      pngs = Dir["#{base_dir}/*.png"].sort.map do |filename|
        convert_for_png2swf(filename)
        
        # Win32 compatibility
        "\"#{filename}\""
      end.join(" ")
      cmd = PNG2SWF % [quality, "\"#{swf_name}\"", pngs]
      system(cmd)
      
      FileUtils.rm_rf(base_dir)
    end
  end
end

class WikiMechanize
  BASE = "http://spacegame.busiu.lt"
  MANTIS = "#{BASE}/mantis"
  WIKI = "#{BASE}/wiki"
  TIMEOUT = 10

  include Singleton

  def file_url(file)
    "#{WIKI}/index.php/File:#{file}"
  end

  def info(message, block_output=false)
    start = Time.now
    $stdout.write "#{message}..."
    $stdout.write block_output ? "\n" : " "
    $stdout.flush

    result = yield

    time = Time.now - start
    puts "Done. (%3.4f seconds)" % time

    result
  end

  def get_content(name)
    info "Getting content from '#{name}'" do
      form, content_box = get_content_box(name)
      content_box.value
    end
  end

  def store_wiki_page(name, content)
    info "Submitting content to '#{name}'" do
      form, content_box = get_content_box(name)
      content_box.value = content
      form.submit
    end
  end

  def download_wiki_file(wiki_filename)
    login

    wiki_url = file_url(wiki_filename)
    success = nil
    hash = nil
    tempfile = nil
    info "Downloading", true do
      puts "  From: #{wiki_url}"

      page = get wiki_url
      a = page.parser.css('div#file a')[0]
      a ||= page.parser.css('div.fullMedia .dangerousLink a')[0]

      success = false
      tempfile = Tempfile.new('wiki')
      if a
        puts "  Real: #{a['href']}"
        puts "  To  : #{tempfile.path}"

        file = get a['href']
        file.save_as tempfile.path
        hash = Assets.hash(tempfile.path)

        success = true
      else
        puts "  Real: MISSING!"
      end
    end
    
    puts

    [success, hash, tempfile]
  end

  def method_missing(name, *args)
    login
    Timeout.timeout(TIMEOUT) do
      @agent.send(name, *args)
    end
  rescue Timeout::Error
    puts "Timed out. Retrying #{name}(#{args.map(&:inspect).join(", ")})."
    @agent = nil
    retry
  end

  private
  def get_content_box(name)
    url = "#{WIKI}/index.php?title=#{name}&action=edit"
    page = get(url)
    form = page.form_with(:name => 'editform')
    [form, form.field_with(:name => 'wpTextbox1')]
  end

  def login
    return if @agent

    require 'mechanize'
    @agent = Mechanize.new
    info "Logging in" do
      post "#{MANTIS}/login.php", "username" => "wiki_access",
        "password" => "8hnlkds%n234b"
    end
  end
end