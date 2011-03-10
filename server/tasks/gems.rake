namespace :gems do
  def install_gems(list)
    # Allow using sudo for system deployment.
    ENV['GEM_CMD'] ||= "gem"

    rubyinstaller = RUBY_PLATFORM =~ /mingw/

    list.each do |gem|
      gem = {:name => gem} unless gem.is_a?(Hash)
      cmd = "#{ENV['GEM_CMD']} query -i -n #{gem[:name]}"
      cmd += " --version \"#{gem[:version]}\"" unless gem[:version].nil?
      cmd += " #{ENV['QUERY_ARGS']}"
      if `#{cmd}`.strip == "false"
        args = ENV['INSTALL_ARGS'] || '--no-rdoc --no-ri'
        cmd = "#{ENV['GEM_CMD']} install #{gem[:name]} #{args}"
        cmd += " --version \"#{gem[:version]}\"" unless gem[:version].nil?
        cmd += " --source #{gem[:source]}" unless gem[:source].nil?
        cmd += " --platform=ruby" if ! gem.has_key?(:platform) && rubyinstaller
        cmd += " --platform=#{gem[:platform]}" unless gem[:platform].nil?
        unless gem[:platform_options].nil?
          gem[:platform_options].each do |platform_re, options|
            cmd += " #{options}" if RUBY_PLATFORM =~ platform_re
          end
        end
        puts "Running: #{cmd}"
        system(cmd)
      end
    end
  end

  desc "Require gem configuration."
  task :config do
    require File.join(File.dirname(__FILE__), '..', 'lib', 'gem_config.rb')
  end

  desc "Install required gems (DOES NOT INSTALL DEV GEMS!)."
  task :install => :config do
    install_gems(REQUIRED_GEMS)
  end

  namespace :install do
    desc "Install gems required for development."
    task :development => :install do
      install_gems(REQUIRED_DEVELOPMENT_GEMS)
    end
  end
end
