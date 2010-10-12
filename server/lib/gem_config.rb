REQUIRED_GEMS = [
  {:name => 'mysql', :version => '>=2.7.0'},
  {:name => 'activerecord', :version => '>=3.0.0', :lib => 'active_record'},
  {:name => 'activesupport', :version => '>=3.0.0', :lib => 'active_support'},
  # Use github version because only it build on win32.
  {:name => 'eventmachine-eventmachine', :version => '>=0.12.6',
    :source => "http://gems.github.com", :lib => "eventmachine"},
  {:name => 'json', :version => '>=1.4.6'},
  {:name => 'seamusabshere-daemons', :version => '>=1.0.11',
    :lib => 'daemons', :source => "http://gems.github.com/"}
]

REQUIRED_DEVELOPMENT_GEMS = [
  "rspec",
  "ruby-prof",
  {:name => "minitar"},
  {:name => "thoughtbot-factory_girl", :source => "http://gems.github.com"},
  {:name => "leehambley-railsless-deploy",
    :source => "http://gems.github.com/"},
  # Needed for mediawiki-gateway, somehow not specified in mw-gw gemfile.
  {:name => "rest-client", :lib => "rest_client"},
  {:name => "mediawiki-gateway", :lib => "media_wiki"},
  "capistrano"
]
