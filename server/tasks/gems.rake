non_dev_gems = "development_setup development_require test_setup test_require"

namespace :gems do
  desc "Install required gems (DOES NOT INSTALL DEV GEMS!)."
  task :install do
    system(%Q{bundle install --without "#{non_dev_gems}"})
  end

  namespace :install do
    desc "Install gems required for development."
    task :development do
      system("bundle install")
    end

    desc "Install gems to vendor/bundle for deployment."
    task :deploy do
      system(%Q{bundle install --deployment --without "#{non_dev_gems}"})
    end
  end
end
