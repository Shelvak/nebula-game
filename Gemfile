source "http://rubygems.org"
source "http://gems.github.com"

gem 'activesupport', '~>3.0.9', :require => 'active_support'
gem 'activerecord', '~>3.0.9', :require => 'active_record'
gem 'json', '>=1.4.6', :require => "json/ext"
gem 'activerecord-jdbcmysql-adapter', '~>1.1'

# Gems that are needed for running (not testing).
group :run_env do
  gem 'eventmachine', '>=0.12.6'
end

# Only needed in production.
group :production_env do
  gem 'mail', '>=2.2'
end

# Gems that are needed but should never be activated.
group :installation do
  gem 'rake', '~>0.9.0'
  gem 'jruby-openssl'
  # For natural date parsing, e.g. "in 5 minutes"
  gem "chronic", ">=0.6.2"
end

# Gems that are only needed for development of the server.
group :development do
  gem "rspec", "~>1.3"
  gem "minitar"
  gem "thoughtbot-factory_girl"
  # Needed for mediawiki-gateway, somehow not specified in mw-gw gemfile.
  gem "rest-client"
  gem "mediawiki-gateway"
  gem "net-ssh", "~>2.0"
  gem "net-sftp", "~>2.0"
  gem "net-scp", "~>1.0"
  gem "xml-simple", "~>1.0"
end
