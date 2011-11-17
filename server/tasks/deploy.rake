STDOUT.sync = true

begin
  require 'net/sftp'
rescue LoadError
  puts "Warning: net/sftp gem could not be loaded, deploy:* " +
    "tasks will not work."
end

PROJECT_ROOT = File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..'))
CLIENT_TARGET = File.join(PROJECT_ROOT, 'flex', 'target', 'dist')

DEPLOY_CONFIG = {
  :username => "spacegame",
  # Number of releases kept in server (including current)
  :releases_kept => 4,
  :release_branch => {
    :stable => "master",
    :beta => "server"
  },

  :servers => {
    :stable => {
      :client => ["morpheus.nebula44.lt"],
      :server => ["morpheus.nebula44.lt"],
    },
    :beta => {
      :client => ["static-beta3.nebula44.com:2022"],
      :server => ["beta3.nebula44.com:1022"],
    },
  },

  :paths => {
    :local => {
      :client => [
        ["", CLIENT_TARGET]
      ],
      :server => [
        File.join("config", "environments"),
        File.join("config", "initializers"),
        File.join("config", "sets"),
        File.join("config", "application.yml"),
        File.join("config", "quests.rb"),
        File.join("db", "migrate"),
        File.join("db", "snapshots", "main.sql"),
        "lib",
        "tasks",
        "run",
        File.join("script", "announce.rb"),
        File.join("script", "apply_hotfix.rb"),
        File.join("script", "dump_galaxy.rb"),
        File.join("script", "log_analyzer.rb"),
        File.join("script", "munin-plugins"),
        File.join("script", "fixes"),
        File.join("vendor", "plugins"),
        File.join("vendor", "SpaceMule", "dist"),
        "Rakefile",
        "Gemfile",
        "Gemfile.lock",
        ".rvmrc",
      ].map do |relative|
        [relative, File.join(PROJECT_ROOT, 'server', relative)]
      end
    },
    :remote => {
      :client => "/home/spacegame/nebula-client",
      :server => "/home/spacegame/nebula-server",
    }
  },
}

DEPLOY_CONFIG_CLIENT_CURRENT = "#{
  DEPLOY_CONFIG[:paths][:remote][:client]}/current"
DEPLOY_CONFIG_SERVER_CURRENT = "#{
  DEPLOY_CONFIG[:paths][:remote][:server]}/current"
FLEX_LOCALES_DIR = File.join(PROJECT_ROOT, 'flex', 'target', 'dist',
  'locale')

class DeployHelpers; class << self
  def info(env, message)
    $stdout.write("[%s] %s %s" % [
        env, Time.now.strftime("%H:%M:%S"), message])

    if block_given?
      start = Time.now
      result = yield
      puts ". (%3.2fs)" % (Time.now - start)
      result
    else
      puts
    end
  end

  def check_git_branch!(env)
    branch = DEPLOY_CONFIG[:release_branch][env]
    raise "You should probably want to switch to '#{branch
      }' branch before deployment for #{env} environment." \
      unless `git branch`.include?("* #{branch}")
  end

  def get_env(env)
    env = (env || :beta).to_sym
    raise ArgumentError.new(
      "Unknown deployment environment #{env}! Known envs: #{
      DEPLOY_CONFIG[:servers].keys.join(", ")}"
    ) unless DEPLOY_CONFIG[:servers].has_key?(env)
    env
  end
  
  def start(klass, server, &block)
    server, port = server.split(":")
    options = port ? {:port => port.to_i} : {}
    
    klass.start(server, DEPLOY_CONFIG[:username], options, &block)
  end

  def deploy(ssh, server, part)
    deploy_dir = "#{DEPLOY_CONFIG[:paths][:remote][part]}/#{
      Time.now.strftime("%Y%m%d%H%M%S")}"
      
    start(Net::SFTP, server) do |sftp|
      DEPLOY_CONFIG[:paths][:local][part].each do
        |remote_path, local_path|

        deploy_path(ssh, sftp, deploy_dir, local_path, remote_path)
      end
    end

    deploy_dir
  end

  def deploy_path(ssh, sftp, deploy_dir, local_path, remote_path)
    if File.exists?(local_path)
      target = "#{deploy_dir}/#{remote_path}"
      ssh.exec!("mkdir -p %s" % File.dirname(target))
      sftp.upload!(local_path, target)
    else
      puts "Error while uploading: #{local_path} does not exist!"
      exit
    end
  end

  def symlink(ssh, deploy_dir)
    releases_dir = File.dirname(deploy_dir)

    releases = ssh.exec!("ls #{releases_dir}").split.map do |dir|
      # Filter string-like directories
      date = dir.to_i
      date == 0 ? nil : date
    end.compact.sort.reverse

    # Slice may return nil
    removed_releases = releases[
      DEPLOY_CONFIG[:releases_kept]..-1
    ] || []

    if removed_releases.size > 0
      ssh.exec!("rm -rf %s" % (removed_releases.map do |release|
          "#{releases_dir}/#{release}"
      end.join(" ")))
      removed = removed_releases.size
      $stdout.write ". #{removed} old #{
        removed == 1 ? "release" : "releases"} removed"
    end

    ssh.exec!("rm -f #{releases_dir}/current")
    ssh.exec!("ln -s #{deploy_dir} #{releases_dir}/current")
  end

  def exec_server(ssh, cmd, use_bundler=true)
    cmd = "bundle exec #{cmd}" if use_bundler

    ssh.exec!("source $HOME/.profile > /dev/null && cd #{
      DEPLOY_CONFIG_SERVER_CURRENT
    } && #{cmd}")
  end
  
  CHECK_SERVER_CMD = "ruby lib/daemon.rb status"
  CHECK_SERVER_OK_RESPONSE = "ok"

  def server_running?(ssh)
    exec_server(ssh, CHECK_SERVER_CMD).strip == CHECK_SERVER_OK_RESPONSE
  end

  STOP_SERVER_CMD = "ruby lib/daemon.rb stop"

  def stop_server(ssh)
    exec_server(ssh, STOP_SERVER_CMD)
    running = server_running?(ssh)
    while running
      $stdout.write(".")

      exec_server(ssh, STOP_SERVER_CMD)
      running = server_running?(ssh)
      
      sleep 1
    end
  end

  START_SERVER_CMD = "ruby lib/daemon.rb start"
  START_SERVER_TIMEOUT = 5

  def start_server(ssh)
    output = exec_server(ssh, START_SERVER_CMD)
    if output.nil?
      sec = 5
      $stdout.write ". Waiting #{sec} seconds to check for status... "
      sleep sec
      running = server_running?(ssh)

      attempt = 0
      until running || attempt >= START_SERVER_TIMEOUT
        $stdout.write(".")
        attempt += 1

        sleep 1
        running = server_running?(ssh)
      end

      $stdout.write(" Server startup FAILED! ") unless running
    else
      puts
      puts "!! Server said something:"
      output.split("\n").each do |line|
        puts "!!   #{line}"
      end
      puts "!!"
    end
  end

  def restart_server(ssh)
    stop_server(ssh)
    start_server(ssh)
  end

  def chmod(ssh)
    current_dir = DEPLOY_CONFIG_SERVER_CURRENT
    ssh.exec!("chmod -R +x #{current_dir}/lib/main.rb #{current_dir
      }/lib/daemon.rb #{current_dir}/lib/daemon/runner.sh #{current_dir
      }/lib/console.rb #{current_dir}/script/*")
  end

  def server_symlink(ssh)
    current_dir = DEPLOY_CONFIG_SERVER_CURRENT
    shared_dir = "#{DEPLOY_CONFIG[:paths][:remote][:server]}/shared"
    %w{log run vendor/bundle}.each do |dir|
      target = "#{current_dir}/#{dir}"
      ssh.exec!("mkdir -p #{shared_dir}/#{dir}")
      ssh.exec!("rm -rf #{target}")
      ssh.exec!("ln -nfs #{shared_dir}/#{dir} #{target}")
    end

    ssh.exec!("ln -nfs ~/config/db.game.yml #{
      current_dir}/config/database.yml")
  end

  def install_gems(ssh)
    response = exec_server(ssh, "rake gems:install:deploy", false)
    puts response
  end

  def migrate_db(ssh)
    response = exec_server(ssh, "rake db:migrate NO_TEST=1")
    puts response
  end

  def load_quests(ssh)
    response = exec_server(ssh, "rake quests:load")
    puts response
  end
end; end

namespace :deploy do
  namespace :client do
    desc "Deploy client locales to given environment"
    task :locales, [:env] do |task, args|
      env = DeployHelpers.get_env(args[:env])
      DeployHelpers.check_git_branch!(env)
      `cd #{PROJECT_ROOT}/flex && rake build:copy:locales`

      DEPLOY_CONFIG[:servers][env][:client].each do |server|
        DeployHelpers.info env, "Deploying locales to #{server}" do
          DeployHelpers.start(Net::SSH, server) do |ssh|
            DeployHelpers.start(Net::SFTP, server) do |sftp|
              ssh.exec!("rm -rf #{DEPLOY_CONFIG_CLIENT_CURRENT}/locale")
              DeployHelpers.deploy_path(ssh, sftp,
                DEPLOY_CONFIG_CLIENT_CURRENT,
                FLEX_LOCALES_DIR,
                "locale")
            end
          end
        end
      end
    end
  end

  desc "Deploy client to given environment"
  task :client, [:env] do |task, args|
    env = DeployHelpers.get_env(args[:env])
    DeployHelpers.check_git_branch!(env)

    DEPLOY_CONFIG[:servers][env][:client].each do |server|
      DeployHelpers.info env, "Deploying client to #{server}" do
        DeployHelpers.start(Net::SSH, server) do |ssh|
          deploy_dir = DeployHelpers.deploy(ssh, server, :client)
          DeployHelpers.symlink(ssh, deploy_dir)
        end
      end
    end
  end

  namespace :server do
    desc "Stop all servers belonging to environment"
    task :start, [:env] do |task, args|
      env = DeployHelpers.get_env(args[:env])
      DEPLOY_CONFIG[:servers][env][:server].each do |server|
        DeployHelpers.info(env, "Starting server on #{server}") do
          DeployHelpers.start(Net::SSH, server) do |ssh|
            DeployHelpers.start_server(ssh)
          end
        end
      end
    end

    desc "Stop all servers belonging to environment"
    task :restart, [:env] do |task, args|
      env = DeployHelpers.get_env(args[:env])
      DEPLOY_CONFIG[:servers][env][:server].each do |server|
        DeployHelpers.info(env, "Restarting server on #{server}") do
          DeployHelpers.start(Net::SSH, server) do |ssh|
            DeployHelpers.restart_server(ssh)
          end
        end
      end
    end

    desc "Stop all servers belonging to environment"
    task :stop, [:env] do |task, args|
      env = DeployHelpers.get_env(args[:env])
      DEPLOY_CONFIG[:servers][env][:server].each do |server|
        DeployHelpers.info(env, "Stopping server on #{server}") do
          DeployHelpers.start(Net::SSH, server) do |ssh|
            DeployHelpers.stop_server(ssh)
          end
        end
      end
    end

    desc "Check if server is running"
    task :status, [:env] do |task, args|
      env = DeployHelpers.get_env(args[:env])
      DEPLOY_CONFIG[:servers][env][:server].each do |server|
        DeployHelpers.start(Net::SSH, server) do |ssh|
          running = DeployHelpers.server_running?(ssh)
          puts "Server on #{server} is " + (
            running ? "running." : "NOT RUNNING!")
        end
      end

    end

    namespace :db do
      [
        [:load, "rake db:load", "Loading main.sql", "Load main.sql"],
        [:reset, "rake db:reset", "Reseting database", "Reset database"]
      ].each do |task_name, remote_cmd, running_msg, description|
        desc "#{description} on all servers belonging to environment"
        task task_name, [:env] do |task, args|
          env = DeployHelpers.get_env(args[:env])
          DEPLOY_CONFIG[:servers][env][:server].each do |server|
            DeployHelpers.info(env, "#{running_msg} on #{server}") do
              DeployHelpers.start(Net::SSH, server) do |ssh|
                DeployHelpers.exec_server(ssh, remote_cmd)
              end
            end
          end
        end
      end
    end

    desc "Cold deploy server to given environment"
    task :cold, [:env] do |task, args|
      env = DeployHelpers.get_env(args[:env])
      DeployHelpers.check_git_branch!(env)

      DEPLOY_CONFIG[:servers][env][:server].each do |server|
        DeployHelpers.info env, "Cold deploying server to #{server}" do
          puts "..."
          DeployHelpers.start(Net::SSH, server) do |ssh|
            deploy_dir = DeployHelpers.info env, "  Sending files" do
              DeployHelpers.deploy(ssh, server, :server)
            end

            DeployHelpers.info env, "  Symlinking" do
              DeployHelpers.symlink(ssh, deploy_dir)
              DeployHelpers.server_symlink(ssh)
            end
            DeployHelpers.info env, "  Chmoding" do
              DeployHelpers.chmod(ssh)
            end
            DeployHelpers.info env, "  Installing gems" do
              DeployHelpers.install_gems(ssh)
            end
          end

          $stdout.write("Done")
        end
      end
    end
  end

  desc "Deploy server to given environment"
  task :server, [:env] do |task, args|
    env = DeployHelpers.get_env(args[:env])
    DeployHelpers.check_git_branch!(env)

    DEPLOY_CONFIG[:servers][env][:server].each do |server|
      DeployHelpers.info env, "Deploying server to #{server}" do
        puts "..."
        DeployHelpers.start(Net::SSH, server) do |ssh|
          deploy_dir = DeployHelpers.info env, "  Sending files" do
            DeployHelpers.deploy(ssh, server, :server)
          end

          DeployHelpers.info env, "  Stopping server" do
            DeployHelpers.stop_server(ssh)
          end

          DeployHelpers.info env, "  Symlinking" do
            DeployHelpers.symlink(ssh, deploy_dir)
            DeployHelpers.server_symlink(ssh)
          end
          DeployHelpers.info env, "  Chmoding" do
            DeployHelpers.chmod(ssh)
          end
          DeployHelpers.info env, "  Installing gems" do
            DeployHelpers.install_gems(ssh)
          end
          DeployHelpers.info env, "  Migrating database" do
            DeployHelpers.migrate_db(ssh)
          end
          DeployHelpers.info env, "  Loading quests" do
            DeployHelpers.load_quests(ssh)
          end

          DeployHelpers.info env, "  Starting server" do
            DeployHelpers.start_server(ssh)
          end
        end

        $stdout.write("Done")
      end
    end
  end
end

desc "Deploy client and server to given environment"
task :deploy, [:env] => ["deploy:client", "deploy:server"]
