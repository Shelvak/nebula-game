set :application, "spacegame"
set :repository,  "ssh://git@nebula44.com/nebula-game.git"
set :deploy_to, '/home/spacegame/app'
set :use_sudo, false

set :scm, :git
set :user, 'spacegame'
set :default_environment, {'environment' => 'production'}
set :branch, 'release'

server "nebula44.com", :app, :web, :db, :primary => true

namespace :deploy do
  task :clean do
        
  end
  before "deploy:clean", "deploy"
  after "deploy:clean", "deploy:db:reset"
  after "deploy:clean", "deploy:restart"

  task :stop do
    run "cd #{deploy_to}/current/server && ruby lib/daemon.rb stop"
  end

  task :start do
    run "cd #{deploy_to}/current/server && authbind ruby lib/daemon.rb start"
  end

  task :restart do
    # Empty task
  end
  before "deploy:restart", "deploy:stop"
  after "deploy:restart", "deploy:start"


  namespace :db do
    task :migrate do
      run "cd #{release_path}/server && rake db:migrate NO_TEST=1"
    end
    
    task :reset do
      run "cd #{release_path}/server && rake db:reset NO_TEST=1"
    end
  end

  namespace :extras do
    desc "Symlink extra things"
    task :symlink do
      # Shared directories
      shared = "#{deploy_to}/shared" 
      run "cd #{shared}/ && mkdir -p server/run server/log web/log"
      run "ln -nfs #{shared}/server/log #{release_path}/server/log"
      run "ln -nfs #{shared}/server/run #{release_path}/server/run"

      # Symlink deployment configs
      run "ln -nfs #{release_path}/production_config/database.yml " +
        "#{release_path}/server/config/database.yml"

      run "ln -nfs #{release_path}/flex/bin-release/SpaceGame.html " +
        "#{release_path}/flex/bin-release/index.html"
      run "mkdir -p #{release_path}/web/public"
      run "ln -nfs #{release_path}/flex/bin-release/ " +
        "#{release_path}/web/public/play"
      run "ln -nfs ~/mantis/ #{release_path}/web/public/mantis"
      run "ln -nfs ~/mediawiki/ #{release_path}/web/public/wiki"
    end

    desc "Set executable flags on files."
    task :chmod do
      run "cd #{release_path}/server/lib && " +
        "chmod +x main.rb console.rb daemon.rb"
    end
  end

  namespace :gems do
    desc "Install required gems on server"
    task :install do
      run "cd #{release_path}/server && rake gems:install " +
        "INSTALL_ARGS='--no-ri --no-rdoc' GEM_CMD='sudo /usr/bin/gem'"
    end
  end
end

after "deploy:update_code", "deploy:extras:symlink"
after "deploy:update_code", "deploy:extras:chmod"
after "deploy:update_code", "deploy:gems:install"
after "deploy:update_code", "deploy:db:migrate"
after "deploy:symlink", "deploy:restart"
