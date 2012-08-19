class Tasks::Assets::Bundler
  # File extensions that are included into bundles.
  SUPPORTED_EXTENSIONS = %w{jpg jpeg png swf mp3}

  # Name of assets config file.
  ASSETS_CONFIG = 'AssetsConfig'
  Asset = Tasks::Assets::Asset

  # Load bundles.yml and construct new Bundler from it.
  def self.from_yaml(yaml_path)
    hash = YAML.load(File.read(yaml_path))
    new(hash['bundles'], hash['modules'])
  end

  def initialize(bundles, modules)
    @bundles = bundles
    @modules = modules
  end

  # Generate contents for AssetsBundle.as.
  def assets_bundle
    contents = %Q!
package assets {

  /**
   * Class that allows accessing bundled assets.
   *
   * This class is autogenerated by 'build:prepare:bundles' rake task.
   */
  public class AssetsBundle {
!

    # IMPORTANT: we sort here to avoid confusion in VCS.
    # Hashes have unpredictable iteration order!
    @modules.keys.sort.each do |name|
      bundles = @modules[name]
      cc_name = name.camelcase

      contents += %Q!
    private static var #{cc_name}Modules : Array = #{bundles.to_json};
    public static function get#{cc_name}Modules() : Array {
      return #{cc_name}Modules;
    }
!
    end

    contents += %Q!
  }
}
!
    contents
  end

  def generate_assets_config(anti_avast, config_dir, compiled_assets_dir)
    basename = "#{ASSETS_CONFIG}.as"
    as_path = File.join(compiled_assets_dir, 'assets', basename)
    files = Dir["#{config_dir}/*.yml"]

    # Find greatest modification time.
    mtime = files.map { |f| File.mtime(f).to_i }.max

    if File.exists?(as_path) && File.mtime(as_path).to_i >= mtime
      puts "[UP TO DATE] #{basename}"
    else
      puts "Generating #{basename}"
      content = assets_config_content(anti_avast, files)
      File.open(as_path, "w") { |f| f.write content }
      Asset.set_mtime(as_path, mtime)
    end
  end

  def generate_bundle_files(prepared_assets_dir, compiled_assets_dir)
    extensions_glob = "*.{#{SUPPORTED_EXTENSIONS.join(",")}}"

    @bundles.each do |name, directories|
      basename = "#{name}.as"
      bundle_as = File.join(compiled_assets_dir, 'assets', basename)
      files = directories.each_with_object([]) do |directory, f|
        glob = "#{prepared_assets_dir}/#{directory}/**/#{extensions_glob}"
        f.concat Dir[glob]
      end

      # Find greatest modification time.
      mtime = files.map { |f| File.mtime(f).to_i }.max

      if File.exists?(bundle_as) && File.mtime(bundle_as).to_i >= mtime
        puts "[UP TO DATE] #{basename}"
      else
        puts "Generating #{basename}"
        content = generate_bundle_as(name, prepared_assets_dir, files)
        File.open(bundle_as, "w") { |f| f.write content }
        Asset.set_mtime(bundle_as, mtime)
      end
    end
  end

  def compile(compiled_assets_dir)
    (@bundles.keys + [ASSETS_CONFIG]).each do |name|
      basename_as = "#{name}.as"
      basename_swf = "#{name}.swf"
      bundle_as = File.join(compiled_assets_dir, 'assets', basename_as)
      bundle_swf = File.join(compiled_assets_dir, basename_swf)

      raise "#{bundle_as} does not exist! Run `rake build:prepare:bundles`!" \
        unless File.exists?(bundle_as)

      mtime = File.mtime(bundle_as).to_i
      if File.exists?(bundle_swf) && File.mtime(bundle_swf).to_i >= mtime
        puts "[UP TO DATE] #{basename_swf}"
      else
        puts "Compiling #{basename_swf}"
        swf_name = compile_swf(compiled_assets_dir, bundle_as)
        FileUtils.mv(swf_name, compiled_assets_dir)
        Asset.set_mtime(bundle_swf, mtime)
      end
    end
  end

private

  def assets_config_content(anti_avast, files)
    config = files.each_with_object({}) do |file, c|
      base = File.basename(file, ".yml")
      YAML.load_file(file).each do |key, value|
        c["#{base}.#{key}"] = value
      end
    end

%Q!
package assets {
  import mx.modules.ModuleBase;
  /**
   * Class for bundled assets configuration items.
   *
   * This class is autogenerated by 'build:prepare:bundles' rake task.
   */
  public class AssetsConfig extends ModuleBase {
    // This is fucking ridiculous. Avast heuristics suck - if .swf has small
    // size and contains no images it will be flaged as virus. FML.
    [Embed(source="#{File.expand_path(anti_avast)}", mimeType="application/octet-stream")]
    private var avastSucks:Class;

    public var config : Object = #{JSON.pretty_generate(config)};
  }
}
!
  end

  def generate_bundle_as(bundle_name, prepared_assets_dir, assets)
    asset_variables = []
    asset_mappings = []
    assets.each do |asset_path|
      var_name = asset_path.gsub(/[^a-z0-9_]/i, "_")
      asset_variables << generate_asset_variable(var_name, asset_path)
      asset_mappings << [
        asset_path.sub(/^#{prepared_assets_dir}\/?/, ''), var_name
      ]
    end

%Q!
package assets {
  import mx.modules.ModuleBase;

  /**
   * Class that bundles assets.
   *
   * This class is autogenerated by 'build:prepare:bundles' rake task.
   */
  public class #{bundle_name} extends ModuleBase
  {

    // Variables with embedded assets
    #{asset_variables.join}

    // Hash for resolving name -> asset.
    private var assetsHash: Object = {
#{
  asset_mappings.map { |name, var_name| %Q{"#{name}": #{var_name}} }.join(",\n")
}
    };

    /**
     * Returns a hash which maps SWFs names to actual classes.
     */
    public function getAssetsHash() : Object
    {
      return assetsHash;
    }
  }
}
!
  end

  def generate_asset_variable(var_name, asset_path)
    mime_type = Asset.mime_type(asset_path)

%Q!
    [Embed(source="#{File.expand_path(asset_path)}", mimeType="#{mime_type}")]
    private var #{var_name}:Class;
!
  end

  def compile_swf(source_path, as_path)
    # -static-rsls to avoid loading flex libs from adobe.
    args = [
      "mxmlc", "-static-rsls=true", "-source-path=#{source_path}", as_path
    ]

    cmd = args.map { |e| '"%s"' % e }.join(" ")
    puts "=> " + cmd
    system(*args)
    unless $?.success?
      puts
      puts "Running `#{cmd}` failed with exit status #{$?.exitstatus}!"
      exit
    end

    as_path.sub(/\.as$/, ".swf")
  end
end