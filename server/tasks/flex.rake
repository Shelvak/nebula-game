require File.expand_path(File.dirname(__FILE__) + '/helpers/assets')

FLEX_ASSET_DIR = File.join(Assets::PROJECT_BASE_DIR, 'flex', 'src',
  'assets')
FLEX_BIN_DEBUG_ASSET_DIR = File.join(Assets::PROJECT_BASE_DIR, 'flex',
  'bin-debug', 'assets')
FLEX_BIN_RELEASE_ASSET_DIR = File.join(Assets::PROJECT_BASE_DIR, 'flex',
  'bin-release', 'assets')
FLEX_LOCALE_DIR = File.join(Assets::PROJECT_BASE_DIR, 'flex',
  'html-template', 'locale')
FLEX_SOURCE_DIR = File.expand_path(
  File.join(Assets::PROJECT_BASE_DIR, 'flex', 'src')
)

# Bundles excluded from normal game
GAME_EXCLUDED_BUNDLES = ["ImagesBattlefieldBundle"]

# Bundles for battlefield
BATTLEFIELD_BUNDLES = [
  "ImagesSolarSystemBundle",
  "ImagesSolarSystemObjectBundle",
  "ImagesBattlefieldBundle",
  "ImagesUiBundle",
  "ImagesTileBundle"
]
# Locale reference regular expression.
LOCALE_REF_RE = /\[reference:((\w+)\/)?(.+?)\]/\

namespace :flex do
  namespace :locales do
    desc "Checks locales for validity"
    task :check do
      require 'xmlsimple'
      errors = {}

      check_locale_value = lambda do |fname, contents, current_bundle, value|
        value.scan(LOCALE_REF_RE) do |unused, bundle, name|
          bundle = current_bundle if bundle.nil?

          if ! contents[bundle][0].has_key?(name)
            ref_name = bundle.nil? ? name : "#{bundle}/#{name}"

            errors[fname] ||= []
            errors[fname].push "[reference:#{ref_name}] is broken!"
          end
        end
      end

      Dir[File.join(FLEX_LOCALE_DIR, "*.xml")].each do |fpath|
        fname = File.basename(fpath)
        contents = XmlSimple.xml_in(fpath)
        contents.each do |bundle_name, bundle_contents|
          if bundle_contents.size > 1
            errors.push "More than one bundle with name #{bundle_name} found!"
          end
          
          bundle_contents[0].each do |key, values|
            value = values[0]

            check_locale_value.call(
              fname, contents, bundle_name,
              value.is_a?(String) \
                ? value \
                : values[0].has_key?('value') \
                  ? values[0]['value'] \
                  : values[0].has_key?('ref') \
                    ? "[reference:#{values[0]['ref']}]" \
                    : values[0]['p'].join("\n")
            )
          end
        end
      end

      if errors.size > 0
        puts "Following errors detected:"
        errors.each do |fname, list|
          puts "  In #{fname}:"
          list.each do |error|
            puts "    * #{error}"
          end
        end
        exit
      else
        puts "Locales are ok."
      end
    end
  end

  namespace :assets do
    desc "Generate assets Flex class"
    task :build => :environment do
      BUNDLED_FILE_HASHES = File.join(Assets::HASHES_DIR,
        'flex_bundled_file_hashes.txt')
      SUPPORTED_EXTENSIONS = "{jpg,png,swf}"
      FileUtils.mkdir_p File.dirname(BUNDLED_FILE_HASHES)

      base = AssetBase.new

      # Set of updated bundles to recompile
      updated_bundles = Set.new
      # Bundles hash with
      #   bundle => {variable_name => local_filename, ...} hashes.
      bundles = {}
      # Module mappings with local_filename => module_name
      # to help AS locate from which bundle file is.
      module_mappings = {}

      # Load hashes
      current_hashes = nil
      old_hashes = Assets.load_hashes(BUNDLED_FILE_HASHES)
      base.decode_target('flex') do |target, target_dir|
        current_hashes = Assets.hash(target_dir)

        # Iterate through assets. Compare them and and add files that have
        # been updated to updated_bundles.
        base.each_bundle do |bundle|
          bundle_data = {}
          bundle_updated = false

          Dir["#{target_dir}/#{bundle.dir}/**/*.#{SUPPORTED_EXTENSIONS}"].each do |filename|
            unless File.directory?(filename)
              filename.sub!("#{target_dir}/", '')

              # Flag bundle as updated
              bundle_updated = true \
                if current_hashes[filename] != old_hashes[filename]

              # Create compiler friendly variable name
              var_name = filename.gsub(/[\/.]/, "__")

              # Assign variable to local filename
              bundle_data[var_name] = [filename, filename]

              # Assign local filename to bundle module file
              module_mappings[filename] = bundle.name
            end
          end

          # Only commit bundle for recompiling if something was updated
          updated_bundles.add(bundle) if bundle_updated

          # Assign data to bundle
          bundles[bundle] = bundle_data
        end
      end

      # Write files.
      # IMPORTANT: we sort here to avoid confusion in VCS.
      # Hashes have unpredictable iteration order!
      FileUtils.mkdir_p FLEX_ASSET_DIR

      # Write AssetsBundle.as
      File.open(File.join(FLEX_ASSET_DIR, 'AssetsBundle.as'), "wb") do |file|
        content = TemplatesBuilder.read_template(
          'AssetsBundle.as',

          '%game_modules%' => bundles.keys.reject do |mod|
            GAME_EXCLUDED_BUNDLES.include?(mod.name)
          end.sort.map { |mod| '"%s"' % mod.name }.join(",\n"),

          '%battle_modules%' => bundles.keys.reject do |mod|
            ! BATTLEFIELD_BUNDLES.include?(mod.name)
          end.sort.map { |mod| '"%s"' % mod.name }.join(",\n")
        )

        file.write content
      end

      bundles.keys.each do |bundle|
        image_variables = []
        image_mappings = []

        bundles[bundle].keys.sort.each do |var_name|
          file_name, embed_file = bundles[bundle][var_name]

          image_variables.push TemplatesBuilder.read_template(
            'ImageVariable.as',

            '%source%' => "../../assets/#{embed_file}",
            '%var_name%' => var_name
          )
          image_mappings.push "      \"#{file_name}\": #{var_name}"
        end

        # Write bundle AS file
        File.open(
          File.join(FLEX_ASSET_DIR, "#{bundle.name}.as"), "wb"
        ) do |file|
          content = TemplatesBuilder.read_template(
            'BundleModule.as',

            '%bundle_name%' => bundle.name,
            '%image_variables%' => image_variables.join("\n"),
            '%image_mappings%' => image_mappings.join(",\n")
          )

          file.write content
        end
      end

      recompiled = false

      # Recompile updated bundles
      bundles.keys.each do |bundle|
        source_file = File.join(FLEX_ASSET_DIR, "#{bundle.name}.as")
        target_file = File.join(FLEX_ASSET_DIR, "#{bundle.name}.swf")

        # Recompile if:
        # * target file is missing
        # or
        # * bundle has been updated
        if ! File.exists?(target_file) || updated_bundles.include?(bundle)
          compile(source_file)
          
          recompiled = true
        end
      end

      Assets.store_hashes(BUNDLED_FILE_HASHES, current_hashes) \
        unless updated_bundles.blank?
      config_updated = update_config
      if recompiled || config_updated
        Rake::Task['flex:assets:copy'].invoke
      else
        puts "Nothing to build. Up to date."
      end
    end

    def compile(source)
      args = ["mxmlc", "-static-rsls=true", 
        "-source-path=#{FLEX_SOURCE_DIR}", source]

      puts "=> " + args.map { |e| '"%s"' % e }.join(" ")
      system(*args)

      source.sub(/\.as$/, '.swf')
    end

    def update_config
      config = {}
      Dir[File.join(Assets::CONFIG_DIR, "*.yml")].each do |file|
        base = File.basename(file, ".yml")
        YAML.load_file(file).each do |key, value|
          config["#{base}.#{key}"] = value
        end
      end

      content = TemplatesBuilder.read_template(
        'AssetsConfig.as',

        '%config%' => JSON.pretty_generate(config)
      )

      # Write AS file
      target = File.join(FLEX_ASSET_DIR, "AssetsConfig.as")
      File.open(target, "wb") do |file|
        file.write content
      end

      old_config = File.join(Assets::HASHES_DIR, "AssetsConfig.as")
      old_content = File.exists?(old_config) \
        ? File.read(old_config) \
        : ""
      if old_content == content
        false
      else
        compile(target)
        FileUtils.cp target, old_config

        true
      end
    end

    desc "Copy built assets to bin-debug directory"
    task :copy => "flex:assets:build" do
      files = Dir[File.join(FLEX_ASSET_DIR, '*.swf')]
      puts "Copying #{files.size} bundles to bin-debug."
      
      FileUtils.rm Dir[File.join(FLEX_BIN_DEBUG_ASSET_DIR, '*.swf')],
        :force => true
      FileUtils.mkdir_p FLEX_BIN_DEBUG_ASSET_DIR
      FileUtils.cp files, FLEX_BIN_DEBUG_ASSET_DIR
    end

    desc "Copy built assets to bin-release directory"
    task :"copy-release" => "flex:assets:build" do
      files = Dir[File.join(FLEX_ASSET_DIR, '*.swf')]
      puts "Copying #{files.size} bundles to bin-release."

      FileUtils.rm Dir[File.join(FLEX_BIN_DEBUG_ASSET_DIR, '*.swf')],
        :force => true
      FileUtils.mkdir_p FLEX_BIN_RELEASE_ASSET_DIR
      FileUtils.cp files, FLEX_BIN_RELEASE_ASSET_DIR
    end
  end
end
