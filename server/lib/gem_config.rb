REQUIRED_GEMS = [
  {:name => 'mysql', :version => '>=2.7.0', :skip => true},
  #{:name => "activerecord-jdbcmysql-adapter", :skip => true},
  {:name => 'activerecord', :version => '>=3.0.3', :lib => 'active_record'},
  {:name => 'activesupport', :version => '>=3.0.3', :lib => 'active_support'},
  {:name => 'eventmachine', :version => '>=0.12.6'},
  {:name => 'json', :version => '>=1.4.6'},
  {:name => 'seamusabshere-daemons', :version => '>=1.0.11',
    :lib => 'daemons', :source => "http://gems.github.com/", :skip => true}
]

REQUIRED_DEVELOPMENT_GEMS = [
  {:name => "rspec", :version => "~>1.3"},
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
