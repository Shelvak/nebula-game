class Tasks::Assets::Processor
  class OptionsEntry < Struct.new(:commit_time, :options); end

  class BadExitStatusError < StandardError
    def initialize(cmd, status)
      @status = status
      super("Bad exit status for `#{cmd}`: #{status.exitstatus}")
    end
  end

  Asset = Tasks::Assets::Asset
  ImageIO = Java::javax.imageio.ImageIO
  BufferedImage = java.awt.image.BufferedImage
  JFile = Java::java.io.File
  DS = File::SEPARATOR

  def initialize(
    bundled_assets_dir, processed_assets_dir, assets_config_dir, debug=false
  )
    raise "bundled_assets_dir is nil!" if bundled_assets_dir.nil?
    raise "processed_assets_dir is nil!" if processed_assets_dir.nil?
    raise "assets_config_dir is nil!" if assets_config_dir.nil?
    @bundled_assets_dir = bundled_assets_dir
    @processed_assets_dir = processed_assets_dir
    @assets_config_dir = assets_config_dir
    @debug = debug
  end

  def invoke
    load_options
    walk(@bundled_assets_dir)
    puts
  end

private

  def commit_time(path)
    Asset.commit_time(path)
  end

  # Returns commit timestamps for _paths_.
  #
  # Fast version for determining multiple timestamps. Order can be random.
  def commit_times(paths)
    Asset.commit_times(paths)
  end

  # Sets time modification time. _timestamp_ must be given in seconds.
  def set_mtime(path, timestamp)
    Asset.set_mtime(path, timestamp)
  end

  def load_options
    @options = {}

    Dir["#{@bundled_assets_dir}/**/*options.yml"].each do |yml|
      rel_path = rel_path(yml)
      dirname = File.dirname(rel_path)

      commit_time = commit_time(yml)
      hash = YAML.load(File.read(yml))
      entry = OptionsEntry.new(commit_time, hash)
      filename = File.basename(rel_path)
      if filename == "options.yml"
        @options[dirname] = entry
      else
        @options[rel_path.sub(/.options.yml$/, '')] = entry
      end
    end
  end

  def walk(directory)
    Dir.foreach(directory) do |entry|
      next if entry == "." || entry == ".."

      full_path = File.join(directory, entry)
      if File.directory?(full_path)
        if File.exists?(File.join(full_path, "metadata.yml"))
          # Animation.
          process_dir(full_path)
        else
          # A regular directory, walk inside.
          walk(full_path)
        end
      elsif entry !~ /options\.yml$/
        # Single asset.
        process_file(full_path)
      end
    end
  end

  def rel_path(bundled_path)
    bundled_path.sub(/^#{@bundled_assets_dir}\/?/, '')
  end

  def process_file(path)
    rel_path = rel_path(path)
    commit_time, options = options_for(rel_path)

    target_dir = File.join(@processed_assets_dir, File.dirname(rel_path))
    raw_target_file = File.join(target_dir, File.basename(rel_path))
    target_file = save_as(raw_target_file, options, true)

    # Determine max commit time.
    commit_time = [commit_time, commit_time(path)].max

    if File.exists?(target_file) && File.mtime(target_file).to_i >= commit_time
      info "."
      debug { "[UP TO DATE] #{rel_path}\n" }
    else
      # Copy file from source path to destination path
      info %Q{#{rel_path}: }
      FileUtils.mkdir_p(target_dir)
      FileUtils.rm raw_target_file if File.exists?(raw_target_file)
      FileUtils.rm target_file if File.exists?(target_file)
      FileUtils.cp(path, raw_target_file)

      imagemagick(raw_target_file, options)
      save_as(raw_target_file, options)
      set_mtime(target_file, commit_time)
      info ".\n"
    end
  end

  def process_dir(path)
    rel_path = rel_path(path)
    commit_time, options = options_for(rel_path)

    raise "'combine' option not specified for #{path}!" \
      if options['combine'].nil?

    method, params = options['combine'].split(":")

    case method
    when 'swf'
      quality, = params

      target_dir = File.join(@processed_assets_dir, File.dirname(rel_path))
      target_tmp_dir = File.join(@processed_assets_dir, rel_path)
      target_swf = File.join(target_dir, "#{File.basename(rel_path)}.swf")
      source_pngs = Dir["#{path}/*.png"].sort
      metadata_path = File.join(path, "metadata.yml")
      assets_config_path = File.join(
        @assets_config_dir,
        "assets.#{rel_path.split(DS).map(&:underscore).join(".")}.yml"
      )

      # Determine max commit time.
      commit_time = (
        [commit_time, commit_time(metadata_path)] + commit_times(source_pngs)
      ).max

      if File.exists?(target_swf) && File.exists?(assets_config_path) &&
          File.mtime(target_swf).to_i >= commit_time &&
          File.mtime(assets_config_path).to_i >= commit_time
        info "."
        debug { "[UP TO DATE] #{rel_path}.swf\n" }
      else
        info "#{rel_path}/*.png: combining to SWF (#{quality}% JPEG)."

        FileUtils.mkdir_p(target_tmp_dir)
        target_pngs = source_pngs.map do |filename|
          destination = File.join(target_tmp_dir, File.basename(filename))
          convert_for_png2swf(filename, destination)
          # Win32 compatibility
          %Q{"#{destination}"}
        end.join(" ")

        cmd = png2swf(quality, "\"#{target_swf}\"", target_pngs)
        system(cmd)

        # Set modification time.
        set_mtime(target_swf, commit_time)

        FileUtils.rm_rf(target_tmp_dir)

        # Copy metadata.
        FileUtils.cp metadata_path, assets_config_path

        info " Done.\n"
      end
    else
      raise "Unknown 'combine' method '#{method}' for #{path}!"
    end
  end

  PNG2SWF = "png2swf -r 20 -z %s -T 10 -o %s %s"
  JPEG2SWF = "jpeg2swf -r 10 -z --quality %d -T 10 --output %s %s"

  def png2swf(quality, target, source)
    PNG2SWF % [
      quality == "png" ? "" : "-j #{quality}",
      target,
      source
    ]
  end

  def jpeg2swf(quality, target, source)
    JPEG2SWF % [
      quality == "png" ? 100 : quality,
      target,
      source
    ]
  end

  # Retrieve options for relative _path_.
  def options_for(path)
    commit_time = 0
    options = {}
    parts = path.split(DS)
    0.upto(parts.size - 1) do |index|
      option_path = File.join(parts[0..index])
      entry = @options[option_path]
      unless entry.nil?
        commit_time = [commit_time, entry.commit_time].max
        options.merge!(entry.options)
      end
    end

    [commit_time, options]
  end

  # Ensure we have a format that png2swf understands.
  def convert_for_png2swf(input_path, output_path)
    # Read input file.
    source_bi = ImageIO.read(JFile.new(input_path))

    # Copy it to ARGB image.
    output_bi = BufferedImage.new(
      source_bi.width, source_bi.height, BufferedImage::TYPE_INT_ARGB
    )
    graphics = output_bi.create_graphics
    graphics.draw_image(source_bi, 0, 0, nil)
    graphics.dispose

    # Write it to file.
    ImageIO.write(output_bi, "png", JFile.new(output_path))
  rescue Exception => e
    STDOUT.write("Error while converting #{input_path} -> #{output_path}!\n")
    raise e
  end

  def imagemagick(path, opts)
    if Asset.image?(path) and not opts['imagemagick'].blank?
      info "P(IMAGE) "
      convert(path, opts['imagemagick'])
    end
  end

  def convert(path, options)
    target_convert = "%s%s" % [path, ".converted"]

    cmd = %Q{convert "%s" %s "%s"} % [path, options, target_convert]

    system(cmd)
    FileUtils.rm path if File.exists?(path)
    FileUtils.mv target_convert, path, :force => true
  end

  # Save _path_ as other filetype. If _dummy_ is true, just return new
  # filename.
  def save_as(path, opts, dummy=false)
    target = path

    unless opts['save_as'].blank?
      type, params = opts['save_as'].split(":")

      case type
      when 'swf'
        quality, = params

        cmd = nil
        if Asset.png?(path)
          target = path.sub(Asset::PNG_RE, '.swf')
          unless dummy
            convert_for_png2swf(path, path)
            cmd = png2swf(quality, %Q{"#{target}"}, %Q{"#{path}"})
          end
        elsif Asset.jpg?(path)
          target = path.sub(Asset::JPG_RE, '.swf')
          cmd = jpeg2swf(quality, %Q{"#{target}"}, %Q{"#{path}"}) unless dummy
        end

        if cmd
          info "->SWF(#{quality}%)"
          system(cmd)
          FileUtils.rm_f path
        end
      when '' then # do nothing
      else
        raise "Unknown 'save_as' type: #{type.inspect}"
      end
    end

    target
  end

  # Output info string.
  def info(string)
    $stdout.write(string)
    $stdout.flush
  end

  def debug
    puts yield if @debug
  end

  def system(*args)
    status = Kernel.system(*args)
    raise BadExitStatusError.new(
      args.map { |a| %Q{"#{a}"} }.join(" "), $?
    ) unless $?.success?
    status
  end
end