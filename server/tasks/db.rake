def each_unique_db_config
  configs = []
  DB_CONFIG.each do |env, config|
    unless configs.include?(config)
      configs.push config
    else
      puts "Warning: skipping #{env} db config because it's not unique."
    end
  end

  configs.each { |config| yield config }
end

namespace :db do
  def clone_test_unless_production!
    unless ENV['environment'] == 'production'
      puts "Cloning database schema to test."
      Rake::Task['db:test:clone'].invoke
    end
  end

  desc "Establish connection to database. (rake dep)"
  task :connection => :environment do
    ActiveRecord::Base.establish_connection(DB_CONFIG[App.env])
    @connection, @connection_id = ActiveRecord::Base.connection_pool.
      checkout_with_id
  end

  desc "Migrate the database through scripts in db/migrate. Target specific " +
    "version with VERSION=x."
  task :migrate => :connection do
    puts "Migrating in #{App.env}..."
    ActiveRecord::Base.establish_connection(DB_CONFIG[App.env])
    ActiveRecord::Migrator.migrate(
      DB_MIGRATIONS_DIR,
      ENV["VERSION"] ? ENV["VERSION"].to_i : nil
    )
    puts "Done!\n"

    clone_test_unless_production!
  end

  namespace :migrate do
    desc "Reapply latest migration to DB."
    task :reapply => :connection do
      check_for_production!

      puts "Rollbacking in #{App.env}..."
      ActiveRecord::Base.establish_connection(DB_CONFIG[App.env])
      ActiveRecord::Migrator.rollback(DB_MIGRATIONS_DIR, 1)
      Rake::Task['db:migrate'].invoke
    end

    desc "Revert last migration."
    task :revert => :connection do
      check_for_production!

      puts "Rollbacking in #{App.env}..."
      ActiveRecord::Base.establish_connection(DB_CONFIG[App.env])
      ActiveRecord::Migrator.rollback(DB_MIGRATIONS_DIR, 1)

      clone_test_unless_production!
    end
  end

  desc "Seed database with initial values. Use ruleset=xxx to change ruleset."
  task :seed => :connection do
    ActiveRecord::Base.establish_connection(DB_CONFIG[App.env])
    require File.join(ROOT_DIR, 'db', 'seeds.rb')
  end

  desc "load, migrate & seed database"
  task :reseed => [:load, :migrate, :seed]

  namespace :password do
    desc 'Clone config/database.sample.yml and write to database.yml ' +
      'with your password set'
    task :set, [:pass] do |task, args|
      dir = File.join(File.dirname(__FILE__), '..', 'config')
      template = File.read(File.join(dir, 'database.sample.yml'))
      File.open(File.join(dir, 'database.yml'), 'w') do |f|
        f.write template.gsub('your_password', args[:pass])
      end
    end
  end


  desc 'Create the databases defined in lib/config.yml'
  task :create => :environment do
    each_unique_db_config do |config|
      create_database(config)
    end
  end

  def create_database(config)
    @charset   = ENV['CHARSET']   || 'utf8'
    @collation = ENV['COLLATION'] || 'utf8_general_ci'
    begin
      ActiveRecord::Base.establish_connection(
        config.merge('database' => nil)
      )
      connection, connection_id = ActiveRecord::Base.connection_pool.
        checkout_with_id
      ActiveRecord::Base.connection.create_database(config['database'],
        :charset => @charset,
        :collation => @collation
      )
      ActiveRecord::Base.establish_connection(config)
    rescue Exception => e
      $stderr.puts "Couldn't create database '#{config['database']}' for " +
        "#{config.inspect}, " +
        "charset: #{@charset}, " +
        "collation: #{@collation} " +
        "(if you set the charset manually, make sure you have a " +
        "matching collation): #{e.inspect}"
    end
  end

  desc 'Drops the database.'
  task :drop => :connection do
    check_for_production!

    each_unique_db_config do |config|
      ActiveRecord::Base.establish_connection(config)
      database = config['database']
      begin
        ActiveRecord::Base.connection.drop_database(database)
      rescue Exception => e
        puts "Couldn't drop '#{database}': #{e.inspect}"
      end
    end
  end

  desc 'Recreates your databases.'
  task :recreate => ["db:drop", "db:create"]

  desc 'Recreates your databases using migrations.'
  task :reset => ["db:recreate", "db:migrate"] do
    Rake::Task['snapshot:save'].invoke("main")
  end

  desc "Loads main snapshot."
  task :load do
    Rake::Task['snapshot:load'].invoke("main")
  end

  namespace :test do
    desc "Clone database from current environment"
    task :clone => :connection do
      # Replace enums to varchars because we create lots of custom subclasses in
      # tests.
      replace_type = lambda do |sql|
        sql.sub(/`type` enum\(.+?\)/i, '`type` varchar(255)')
      end

      ActiveRecord::Cloner.clone_db(
        DB_CONFIG[App.env], DB_CONFIG['test'],
        units: [replace_type],
        buildings: [replace_type],
        technologies: [replace_type],
      )
    end
  end
end
