SNAPSHOT_DIR = File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'db', 'snapshots')
)

def snapshot_path(name)
  "%s.sql" % File.join(SNAPSHOT_DIR, name)
end

namespace :snapshot do
  desc "List all snapshots"
  task :list do
    puts "Snapshots in #{SNAPSHOT_DIR}/:"
    puts
    Dir["#{SNAPSHOT_DIR}/*.sql"].each do |file|
      puts "  * %s" % File.basename(file, ".sql")
    end
  end

  desc "Grab a snapshot of database and save it to file"
  task :save, [:name] => :environment do |task, args|
    path = snapshot_path(args[:name])
    puts "Dumping DB to #{path} ..."
    `
      mysqldump \
      "--host=#{USED_DB_CONFIG['host']}" \
      "--user=#{USED_DB_CONFIG['username']}" \
      "--password=#{USED_DB_CONFIG['password']}" \
      "--add-drop-database" \
      "--add-drop-table" \
      "--extended-insert" \
      "--quick" \
      #{USED_DB_CONFIG['database']} \
      > "#{path}"
    `
    puts "Done."
  end

  namespace :save do
    desc "Grab a snapshot of database tables and save it to file"
    task :tables, [:name, :tables] => :environment do |task, args|
      path = snapshot_path(args[:name])
      puts "Dumping DB tables '#{args[:tables].split.join(", ")
        }' to #{path} ..."
      
      `
        mysqldump \
        "--host=#{USED_DB_CONFIG['host']}" \
        "--user=#{USED_DB_CONFIG['username']}" \
        "--password=#{USED_DB_CONFIG['password']}" \
        "--add-drop-table" \
        "--extended-insert" \
        "--quick" \
        #{USED_DB_CONFIG['database']} \
        #{args[:tables]} \
        > "#{path}"
      `
      puts "Done."
    end
  end

  desc "Load snapshot of database from file"
  task :load, [:name] => :environment do |task, args|
    path = snapshot_path(args[:name])
    puts "Loading DB from #{path}..."
    `
      mysql \
      "--host=#{USED_DB_CONFIG['host']}" \
      "--user=#{USED_DB_CONFIG['username']}" \
      "--password=#{USED_DB_CONFIG['password']}" \
      #{USED_DB_CONFIG['database']} \
      < "#{path}"
    `
    puts "Done."

    puts "Cloning database schema to test."
    Rake::Task['db:test:clone'].invoke
  end
end