def generate_file(file_name, content)
  file_name = File.expand_path(file_name)
  dirname = File.dirname(file_name)
  FileUtils.mkdir_p dirname unless File.exists?(dirname)

  unless File.exists?(file_name)
    puts "[generating] #{file_name}"
    File.open(file_name, 'w') { |file| file.write content.strip }
  else
    puts "[exists] #{file_name}"
  end
end

def get_names(name)
  klass = name.camelcase
  file_name = "#{name.underscore}.rb"
  spec_name = "#{name.underscore}_spec.rb"
  migration_name = "#{Time.now.strftime("%Y%m%d%H%M%S")}_" +
    "#{name.gsub("::", "").underscore}.rb"

  [klass, file_name, spec_name, migration_name]
end

def append_config_values(file_path, config_type, name, regexp, content)
  if File.read(file_path).match(regexp)
    puts "[exists] #{config_type} for #{name}"
  else
    puts "[append] #{config_type} for #{name} => #{file_path}"
    File.open(file_path, "a+") do |file|
      file.write("\n#{content}")
    end
  end
end

LOCALES_DIR = File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'flex', 'locale')
)
def generate_locales(klass, type)
  klass = klass.to_s.camelcase.pluralize
  type = type.to_s.camelcase
  file_name = "#{klass}.properties"

  Dir[File.join(LOCALES_DIR, '*', file_name)].each do |file_path|
    content =<<EOF
#{type}.name=TODO: #{type.underscore.humanize}
#{type}.about=TODO: #{type.underscore.humanize
    } is a very powerful #{klass.singularize.downcase}
EOF
    append_config_values(file_path, 'locale', type, /^#{type}\./, content)
  end
end

namespace :generate do
  desc "Generate a migration."
  task :migration, [:name] => :environment do |task, args|
    class_name, file_name, spec_name, migration_name = get_names(args[:name])
    file_name = File.join(File.dirname(__FILE__), '..', 'db', 'migrate', migration_name)
    content =<<EOF
class #{class_name} < ActiveRecord::Migration
  def self.up

  end

  def self.down
    raise IrreversibleMigration
  end
end
EOF
    generate_file(file_name, content)
  end

  desc "Generate a trait."
  task :trait, [:name] => :environment do |task, args|
    class_name, file_name, spec_name, migration_name = get_names(args[:name])
    content =<<EOF
module Trait::#{class_name}
	module ClassMethods

	end

	module InstanceMethods
    
	end

	def self.included(receiver)
    Trait.child_included(self, receiver)
	end
end
EOF
    file_name = File.join(ROOT_DIR, 'lib', 'app', 'models', 'trait', file_name)
    generate_file(file_name, content)

    # Spec
    dots = Array.new(class_name.scan("::").size + 1, "'..'").join(", ")
    file_name = File.join(ROOT_DIR, 'spec', 'models', 'trait', spec_name)
    content =<<EOF
require File.join(File.dirname(__FILE__), #{dots}, '..', 'spec_helper.rb')

class Building::#{class_name}TraitMock < Building
  include Trait::#{class_name}
end

Factory.define :b_#{class_name.underscore}_trait, :parent => :b_trait_mock,
:class => Building::#{class_name}TraitMock do |m|; end

describe Trait::#{class_name} do
  
end
EOF
    generate_file(file_name, content)
  end

  desc "Generate a model."
  task :model, [:name] => :environment do |task, args|
    class_name, file_name, spec_name, migration_name = get_names(args[:name])

    file_name = File.join(ROOT_DIR, 'lib', 'app', 'models', file_name)
    base_klass = class_name.include?("::") \
      ? class_name.split("::")[0..-2].join("::") \
      : "ActiveRecord::Base"
    content =<<EOF
class #{class_name} < #{base_klass}

end
EOF
    generate_file(file_name, content)

    # Namespaced classes don't usually require table or separate factory
    unless class_name.include?("::")
      # Migration
      migration_dir = File.join(ROOT_DIR, 'db', 'migrate')
      migration_name = migration_name.split("_").insert(1, "create").join("_")

      # Check if migration with same name but other date doesn't exist
      migration_name_wo_date = migration_name.split("_", 2)[1]
      if Dir["#{migration_dir}/*_%s" % migration_name_wo_date].blank?
        file_name = File.join(migration_dir, migration_name)
        table_name = args[:name].underscore.pluralize
        content =<<EOF
class Create#{class_name} < ActiveRecord::Migration
  def self.up
    create_table :#{table_name} do |t|

    end
  end

  def self.down
    drop_table :#{table_name}
  end
end
EOF
        generate_file(file_name, content)
      else
        puts "[exists] migration: #{migration_name_wo_date}"
      end

      # Factory
      file_name = File.join(ROOT_DIR, 'spec', 'factories',
        "#{args[:name].pluralize.underscore}_factory.rb")
      content =<<EOF
Factory.define :#{class_name.underscore} do |m|

end
EOF
      generate_file(file_name, content)
    else
      base, name = class_name.split("::", 2)
      file_name = File.join(ROOT_DIR, 'spec', 'factories',
        "#{base.pluralize.underscore}_factory.rb")
      factory_name = "#{base.underscore[0].chr}_#{name.underscore}"
      parent = base == "Building" ? "building_built" : base.underscore

      content =<<EOF
Factory.define :#{factory_name}, :parent => :#{parent},
:class => #{class_name} do |m|; end
EOF
      append_config_values(file_name, 'factory', name,
        /^Factory\.define :#{factory_name}/, content)

      case base
      when "Building", "Technology", "Unit"
        config_file = File.join(ROOT_DIR, 'config', 'sets', 'default',
          'sections', "#{base.pluralize.underscore}.yml")
        config_entry = name.underscore

        generate_locales(base, name)
        append_config_values(config_file, 'config', name,
          /^#{config_entry}/, 
          TemplatesBuilder.read_template(
            "#{base}.config",
            '%config_entry%' => config_entry
          )
        )
      end
    end

    # Spec
    dots = Array.new(class_name.scan("::").size + 1, "'..'").join(", ")
    file_name = File.join(ROOT_DIR, 'spec', 'models', spec_name)
    content =<<EOF
require File.join(File.dirname(__FILE__), #{dots}, 'spec_helper.rb')

describe #{class_name} do
end
EOF
    generate_file(file_name, content)
  end

  desc "Generate a class."
  task :class, [:name] => :environment do |task, args|
    class_name, file_name, spec_name, migration_name = get_names(args[:name])

    file_name = File.join(ROOT_DIR, 'lib', 'app', 'classes', file_name)
    content =<<EOF
class #{class_name}

end
EOF
    generate_file(file_name, content)

    # Spec
    dots = Array.new(class_name.scan("::").size + 1, "'..'").join(", ")
    file_name = File.join(ROOT_DIR, 'spec', 'classes', spec_name)
    content =<<EOF
require File.join(File.dirname(__FILE__), #{dots}, 'spec_helper.rb')

describe #{class_name} do
  before(:each) do
    @object = #{class_name}.new
  end
end
EOF
    generate_file(file_name, content)
  end

  desc "Generate a controller."
  task :controller, [:name] => :environment do |task, args|
    name = args[:name]
    name += "Controller" unless name.match(/controller$/i)
    class_name, file_name, spec_name, migration_name = get_names(name)

    file_name = File.join(ROOT_DIR, 'lib', 'app', 'controllers', file_name)
    content =<<EOF
class #{class_name} < GenericController
  def invoke(action)
    case action
    when ''

    end
  end
end
EOF
    generate_file(file_name, content)

    file_name = File.join(ROOT_DIR, 'spec', 'controllers', spec_name)
    content =<<EOF
require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe #{class_name} do
  include ControllerSpecHelper

  before(:each) do
    init_controller #{class_name}, :login => true
  end
end
EOF
    generate_file(file_name, content)
  end
end