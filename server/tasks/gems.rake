non_dev_gems = "development_setup development_require test_setup test_require"

namespace :gems do
  desc "Install gems required for running and development."
  task :install do
    system(%Q{bundle install"})
  end

  namespace :install do
    desc "Install gems to vendor/bundle for deployment."
    task :deploy do
      system(%Q{bundle install --deployment --without "#{non_dev_gems}"})
    end
  end
end
