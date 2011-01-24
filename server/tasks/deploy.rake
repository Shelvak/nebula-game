begin
  require 'net/sftp'
rescue LoadError
  puts "Warning: net/sftp gem could not be loaded, deploy:* " +
    "tasks will not work."
end

PROJECT_ROOT = File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..'))

DEPLOY_CONFIG = {
  :username => "spacegame",
  # Number of releases kept in server (including current)
  :releases_kept => 2,
  :release_branch => "master",

  :servers => {
    :stable => {
      :client => ["static1.nebula44.com"],
      :server => ["game1.nebula44.com"],
    },
    :beta => {
      :client => ["nebula44.com"],
      :server => ["nebula44.com"],
    },
  },

  :paths => {
    :local => {
      :client => [
        ["", File.join(PROJECT_ROOT, 'flex', 'bin-release')]
      ],
      :server => [
        File.join("config", "environments"),
        File.join("config", "initializers"),
        File.join("config", "sets"),
        File.join("config", "application.yml"),
        File.join("db", "migrate"),
        File.join("db", "snapshots", "main.sql"),
        "lib",
        "tasks",
        "vendor",
        "Rakefile"
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

class DeployHelpers; class << self
  def info(env, message)
    $stdout.write("[%s] %s %s" % [
        env, Time.now.strftime("%H:%M:%S"), message])
    $stdout.flush

    if block_given?
      start = Time.now
      result = yield
      puts ". (%3.2fs)" % (Time.now - start)
      result
    else
      puts
    end
  end

  def check_git_branch!
    branch = DEPLOY_CONFIG[:release_branch]
    raise "You should probably want to switch to '#{branch
      }' branch before deployment.#" \
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

  def deploy(ssh, server, part)
    deploy_dir = "#{DEPLOY_CONFIG[:paths][:remote][part]}/#{
      Time.now.strftime("%Y%m%d%H%M%S")}"

    Net::SFTP.start(server, DEPLOY_CONFIG[:username]) do |sftp|
      DEPLOY_CONFIG[:paths][:local][part].each do
        |remote_path, local_path|

        target = "#{deploy_dir}/#{remote_path}"
        ssh.exec!("mkdir -p %s" % File.dirname(target))
        sftp.upload!(local_path, target)
      end
    end

    deploy_dir
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
      ssh.exec!("rm -rf %s" % removed_releases.map do |release|
          "#{releases_dir}/#{release}"
      end)
    end

    ssh.exec!("rm -f #{releases_dir}/current")
    ssh.exec!("ln -s #{deploy_dir} #{releases_dir}/current")
  end

  def exec_server(ssh, cmd)
    ssh.exec!("cd #{DEPLOY_CONFIG[:paths][:remote][:server]
      }/current && environment=production #{cmd}")
  end

  def server_running?(ssh)
    status = exec_server(ssh, "ps aux | grep -v grep | grep nebula_server")
    ! status.nil?
  end

  STOP_SERVER_CMD = "ruby lib/daemon.rb stop"

  def stop_server(ssh)
    exec_server(ssh, STOP_SERVER_CMD)
    running = server_running?(ssh)
    while running
      $stdout.write(".")
      $stdout.flush

      exec_server(ssh, STOP_SERVER_CMD)
      running = server_running?(ssh)
      
      sleep 1
    end
  end

  START_SERVER_CMD = "authbind ruby lib/daemon.rb start"
  START_SERVER_TIMEOUT = 10

  def start_server(ssh)
    output = exec_server(ssh, START_SERVER_CMD)
    if output.nil?
      running = server_running?(ssh)

      attempt = 0
      until running || attempt >= START_SERVER_TIMEOUT
        $stdout.write(".")
        $stdout.flush
        attempt += 1

        sleep 1
        running = server_running?(ssh)
      end

      $stdout.write("Server startup failed! ") unless running
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

  def server_symlink(ssh)
    current_dir = "#{DEPLOY_CONFIG[:paths][:remote][:server]}/current"
    shared_dir = "#{DEPLOY_CONFIG[:paths][:remote][:server]}/shared"
    %w{log run}.each do |dir|
      ssh.exec!("mkdir -p #{shared_dir}/#{dir}")
      ssh.exec!("ln -nfs #{shared_dir}/#{dir} #{current_dir}/#{dir}")
    end

    ssh.exec!("ln -nfs ~/config/db.game.yml #{
      current_dir}/config/database.yml")
  end

  def install_gems(ssh)
    exec_server(ssh, "rake gems:install INSTALL_ARGS='--no-ri --no-rdoc' " +
      "GEM_CMD='sudo /usr/bin/gem'")
  end

  def migrate_db(ssh)
    exec_server(ssh, "rake db:migrate NO_TEST=1")
  end
end; end

namespace :deploy do
  desc "Deploy client to given environment"
  task :client, [:env] do |task, args|
    DeployHelpers.check_git_branch!
    env = DeployHelpers.get_env(args[:env])

    DEPLOY_CONFIG[:servers][env][:client].each do |server|
      DeployHelpers.info env, "Deploying client to #{server}" do
        Net::SSH.start(server, DEPLOY_CONFIG[:username]) do |ssh|
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
          Net::SSH.start(server, DEPLOY_CONFIG[:username]) do |ssh|
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
          Net::SSH.start(server, DEPLOY_CONFIG[:username]) do |ssh|
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
          Net::SSH.start(server, DEPLOY_CONFIG[:username]) do |ssh|
            DeployHelpers.stop_server(ssh)
          end
        end
      end
    end

    desc "Check if server is running"
    task :status, [:env] do |task, args|
      env = DeployHelpers.get_env(args[:env])
      DEPLOY_CONFIG[:servers][env][:server].each do |server|
        Net::SSH.start(server, DEPLOY_CONFIG[:username]) do |ssh|
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
              Net::SSH.start(server, DEPLOY_CONFIG[:username]) do |ssh|
                DeployHelpers.exec_server(ssh, remote_cmd)
              end
            end
          end
        end
      end
    end
  end

  desc "Deploy server to given environment"
  task :server, [:env] do |task, args|
    DeployHelpers.check_git_branch!
    env = DeployHelpers.get_env(args[:env])

    DEPLOY_CONFIG[:servers][env][:server].each do |server|
      DeployHelpers.info env, "Deploying server to #{server}" do
        puts "..."
        Net::SSH.start(server, DEPLOY_CONFIG[:username]) do |ssh|
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
          DeployHelpers.info env, "  Installing gems" do
            DeployHelpers.install_gems(ssh)
          end
          DeployHelpers.info env, "  Migrating database" do
            DeployHelpers.migrate_db(ssh)
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
task :deploy, [:env] => ["deploy:server", "deploy:client"]
