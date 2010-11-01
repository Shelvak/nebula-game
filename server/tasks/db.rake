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
  desc "Establish connection to database. (rake dep)"
  task :connection => :environment do
    ActiveRecord::Base.establish_connection(
      DB_CONFIG[ENV['environment']]
    )
  end

  desc "Migrate the database through scripts in db/migrate. Target specific " +
    "version with VERSION=x."
  task :migrate => [:environment] do
    env = ENV['environment']

    puts "Migrating in #{env}..."
    ActiveRecord::Base.establish_connection(DB_CONFIG[env])
    ActiveRecord::Migrator.migrate(
      File.dirname(__FILE__) + '/../db/migrate',
      ENV["VERSION"] ? ENV["VERSION"].to_i : nil
    )
    puts "Done!\n"

    unless ENV['environment'] == 'production'
      puts "Cloning database schema to test."
      Rake::Task['db:test:clone'].invoke
    end
  end

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
  task :drop => [:environment] do
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
    task :clone => :environment do
      env = ENV['environment']
      ActiveRecord::Base.establish_connection(DB_CONFIG[env])

      # Get table data
      tables = []
      ActiveRecord::Base.connection.tables.reject do |table|
        table == 'schema_migrations'
      end.each do |table|
        res = ActiveRecord::Base.connection.select_one("SHOW CREATE TABLE `#{table}`")
        tables.push res["Create Table"]
      end

      ActiveRecord::Base.establish_connection(DB_CONFIG['test'])

      # Disable FK checks
      ActiveRecord::Base.connection.execute('SET foreign_key_checks = 0')

      # Drop existing tables
      ActiveRecord::Base.connection.tables.each do |table|
        ActiveRecord::Base.connection.execute("DROP TABLE `#{table}`")
      end

      # Create tables
      tables.each { |sql| ActiveRecord::Base.connection.execute(sql) }
    end
  end
end
