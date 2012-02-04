module GameConfig::Creation
  def self.included(receiver)
    receiver.extend ClassMethods
    super(receiver)
  end

  module ClassMethods
    # Reads file from _path_ and returns its contents (with ERB templates
    # expanded).
    def read_file(*path)
      filename = File.expand_path(File.join(*path))
      template = ERB.new(File.read(filename))
      contents = template.result(binding)
      YAML.load(contents)
    rescue Exception => e
      STDERR.write "Error while reading config #{filename}!\n\n"
      STDERR.write "File contents: \n#{
        defined?(contents) ? contents : "not read yet"
      }\n"
      STDERR.write e.backtrace + "\n\n"
      raise e
    end
  end

  def dump(path)
    File.open(path, "w") do |file|
      Marshal.dump({
        :keys => @keys,
        :data => @data,
        :fallbacks => @fallbacks
      }, file)
    end
    path
  end

  def load(path)
    data = Marshal.load(File.read(path))
    @keys = data[:keys]
    @data = data[:data]
    @fallbacks = data[:fallbacks]
    true
  end

  # Setup config, either using cache (if its not outdated) or by reading
  # config from the disk.
  def setup!(config_dir, cache_dir)
    current_hashes, fallbacks = gather_data(config_dir)
    cached_hashes = File.expand_path(
      File.join(cache_dir, "config_hashes.cache")
    )

    cached_config = File.expand_path(
      File.join(cache_dir, "config_data.cache")
    )

    if File.exists?(cached_hashes) &&
        Marshal.load(File.read(cached_hashes)) == current_hashes &&
        File.exists?(cached_config)
      LOGGER.block "Loading config from cache." do
        load(cached_config)
      end
      @from_cache = true # We use this in #setup_initialize!
      return true
    end

    LOGGER.block(
      "Config cache does not exist or is invalid! Loading config from disk."
    ) do
      fallbacks.each do |set_name, fallback|
        add_set(set_name, fallback)
      end

      current_hashes.each do |(set, scope, filename), hash|
        if filename.ends_with?(".yml")
          contents = self.class.read_file(filename)
          raise "Eh? #{filename} was empty!" if contents.nil?
          if scope.nil?
            merge!(contents, set)
          else
            with_scope(scope) { merge!(contents, set) }
          end
        elsif filename.ends_with?(".rb")
          # Delay initialization of these until #setup_initializers!
        else
          raise "Unknown config file type: #{filename}"
        end
      end
    end

    # Store data for #setup_initializers!
    @setup_current_hashes = current_hashes
    @setup_cached_config = cached_config

    LOGGER.info "Saving config hashes to cache."
    File.open(cached_hashes, "wb") { |f| Marshal.dump(current_hashes, f) }

    true
  end

  # Run initializer code.
  #
  # This must be done AFTER plugins/etc is loaded, because that code actually
  # references actual classes/runs actual methods that won't work if:
  # a) base config is not loaded.
  # b) code is not fully setuped.
  #
  # This creates this unholy mess of stupid initialization. I'd smack myself
  # if I had an ability to travel 2 years back in time. Eh...
  def setup_initializers!
    # We don't need this bullshit if we load from cache.
    return true if @from_cache

    LOGGER.block "Running config initializers" do
      @setup_current_hashes.each do |(set, scope, filename), hash|
        require filename if filename.ends_with?(".rb")
      end
    end

    LOGGER.info "Saving config to cache (#{@setup_cached_config})."
    dump(@setup_cached_config)
    true
  end

  private
  # Gather data needed to either load from cache or load from disk.
  def gather_data(config_dir)
    files = {}
    fallbacks = {}

    # Merge server-level config
    file = lambda do |set, scope, *path|
      filename = File.expand_path(File.join(*path))
      if File.exists?(filename)
        files[[set, scope, filename]] =
          Digest::SHA1.hexdigest(File.read(filename))
      end
    end

    # Main application config.
    file[GameConfig::DEFAULT_SET, nil, config_dir, 'application.yml']

    # Config sets.
    sets_dir = File.expand_path(File.join(config_dir, 'sets'))
    Dir["#{sets_dir}/*"].each do |dir_name|
      set_name, fallback_name = File.basename(dir_name).split("-")

      fallbacks[set_name] = fallback_name \
        unless set_name == GameConfig::DEFAULT_SET

      # Set main config file.
      file[set_name, nil, dir_name, 'application.yml']

      # Sections.
      Dir[File.join(dir_name, 'sections', '**', '*.yml')].sort.each do |path|
        section = File.basename(path, ".yml")
        file[set_name, section, path]
      end

      # ENV config is great for overrides (i.e. in test)
      file[set_name, nil, dir_name, "#{ENV['configuration']}.yml"]
    end

    # Finally load config generation initializers.
    initializers_dir = File.join(config_dir, 'initializers')
    raise "#{initializers_dir} must be a directory!" \
      unless File.directory?(initializers_dir)

    Dir[File.join(initializers_dir, '*.rb')].each do |path|
      file[nil, nil, path]
    end

    [files, fallbacks]
  end
end