REQUIRED_GEMS = [
  {:name => 'jruby-openssl', :skip => true},
  {:name => 'activerecord-jdbcmysql-adapter',
    :version => '~>1.1', :skip => true},
  {:name => 'activesupport', :version => '>=3.0.5', :lib => 'active_support'},
  {:name => 'activerecord', :version => '>=3.0.5', :lib => 'active_record'},
  {:name => 'eventmachine', :version => '>=0.12.6', :env => "!test"},
  {:name => 'json', :version => '>=1.4.6', :lib => "json/ext"},
  {:name => 'mail', :version => '>=2.2', :env => "production"},
]

REQUIRED_DEVELOPMENT_GEMS = [
  {:name => "rspec", :version => "~>1.3"},
  {:name => "minitar"},
  {:name => "thoughtbot-factory_girl", :source => "http://gems.github.com"},
  # Needed for mediawiki-gateway, somehow not specified in mw-gw gemfile.
  {:name => "rest-client", :lib => "rest_client"},
  {:name => "mediawiki-gateway", :lib => "media_wiki"},
  {:name => "net-ssh", :version => "~>2.0", :skip => true},
  {:name => "net-sftp", :version => "~>2.0", :skip => true},
  {:name => "net-scp", :version => "~>1.0", :skip => true},
  {:name => "xml-simple", :version => "~>1.0", :skip => true},
]
