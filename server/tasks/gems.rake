namespace :gems do
  desc "Install required gems (DOES NOT INSTALL DEV GEMS!)."
  task :install do
    system("bundler install --without development")
  end

  namespace :install do
    desc "Install gems required for development."
    task :development do
      system("bundler install")
    end

    desc "Install gems to vendor/bundle for deployment."
    task :deploy do
      system("bundler install --deployment --without development")
    end
  end
end
