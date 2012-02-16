source "http://rubygems.org"
source "http://gems.github.com"

# Gems that are necessary for correct functioning of the server.
gem 'activesupport', '~>3.2.0', :require => 'active_support'
gem 'activerecord', '~>3.2.0', :require => 'active_record'
gem 'json', '>=1.4.6', :require => "json/ext"
gem 'activerecord-jdbcmysql-adapter', '~>1.1'
gem 'flag_shih_tzu', :git => "git://github.com/arturaz/flag_shih_tzu.git"
# For natural date parsing, e.g. "in 5 minutes"
gem "chronic", ">=0.6.2"

# Gems that are needed but should never be activated.
group :installation do
  gem 'rake', '~>0.9.0'
end

# Gems that are needed for running (not testing).
group :run_require do
  gem 'eventmachine', '>=0.12.6'
end

# Only needed in production.
group :production_require do
  gem 'mail', '>=2.2'
end

group :development_require do
end

group :development_require, :test_require do
  # Earlier versions fail on jruby/win32
  gem 'pry', :git => "git://github.com/pry/pry.git"
end

# Gems that are only needed for development of the server. Setuped
group :development_setup do
  gem "minitar"
  # Needed for mediawiki-gateway, somehow not specified in mw-gw gemfile.
  gem "rest-client"
  gem "mediawiki-gateway"

  # 0.7.6 is buggy and cannot be installed.
  # http://jira.codehaus.org/browse/JRUBY-6455
  gem 'jruby-openssl', '>=0.7.6.1'
  gem "net-ssh", :git => "git://github.com/arturaz/net-ssh.git"
  gem "net-sftp"#, :git => "git://github.com/net-ssh/net-sftp.git"
  gem "net-scp"#, :git => "git://github.com/net-ssh/net-scp.git"
  gem "xml-simple", "~>1.0"
end

# Only setuped, but not required (in test env).
group :test_setup do
  gem "rspec", "~>2.7.0"
  gem "factory_girl", "~>2.1.2"
end
