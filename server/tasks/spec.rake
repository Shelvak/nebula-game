begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new

  desc "Run all examples with RCov"
  RSpec::Core::RakeTask.new('rcov') do |t|
    t.rcov = true
    t.rcov_opts = ['--exclude', 'spec']
  end

  namespace :spec do
    [:controllers, :models, :classes, :server].each do |type|
      desc "Run specs for #{type}."
      RSpec::Core::RakeTask.new(type) do |t|
        t.pattern = "spec/#{type}/**/*_spec.rb"
      end

      desc "Run rcov for #{type}."
      RSpec::Core::RakeTask.new("rcov_#{type}") do |t|
        t.pattern = "spec/#{type}/**/*_spec.rb"
        t.rcov = true
        t.rcov_opts = ['--exclude', 'spec']
      end
    end

    desc "Run specs in pairs of two to determine WTF factor."
    task :wtf, [:spec] => :environment do |task, args|
      if args[:spec].nil?
        puts "Invoke me with `rake spec:wtf[path/to/spec.rb]`"
      else
        file = args[:spec]
        if File.file?(file)
          Dir[ENV['glob'] || 'spec/**/*_spec.rb'].each do |other|
            unless file == other
              pair = "#{other} #{file}"
              puts "******** Invoking rspec #{pair}"
              out = `rspec #{pair} 2>&1`
              unless $? == 0
                puts "Seems that these two don't work well together."
                puts out
                exit
              end
              puts
            end
          end
        else
          puts "rspec #{file.inspect} must be file!"
        end
      end
    end
  end
rescue LoadError
  desc "RSpec not installed."
  task :spec do
    puts "RSpec not installed. Run `gem install rspec` to enable this task."
  end
end