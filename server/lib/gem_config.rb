REQUIRED_GEMS = [
  {:name => 'activerecord', :version => '>=3.0.5', :lib => 'active_record'},
  {:name => 'activesupport', :version => '>=3.0.5', :lib => 'active_support'},
  {:name => 'eventmachine', :version => '>=0.12.6',
    # mingw needs dev version to compile.
    :platform_options => {/mingw/ => "--pre"}},
  {:name => 'json', :version => '>=1.4.6', :lib => "json/ext"},
  {:name => 'robustthread', :version => '>=0.5.2', :skip => true},
  {:name => 'mail', :version => '>=2.2'},
  {:name => 'mysql2', :version => '>=0.2.6', :skip => true,
    :platform => nil}
]

REQUIRED_DEVELOPMENT_GEMS = [
  {:name => "rspec", :version => "~>1.3"},
  "ruby-prof",
  {:name => "minitar"},
  {:name => "thoughtbot-factory_girl", :source => "http://gems.github.com"},
  # Needed for mediawiki-gateway, somehow not specified in mw-gw gemfile.
  {:name => "rest-client", :lib => "rest_client"},
  {:name => "mediawiki-gateway", :lib => "media_wiki"},
  {:name => "net-ssh", :version => "~>2.0", :skip => true},
  {:name => "net-sftp", :version => "~>2.0", :skip => true},
  {:name => "net-scp", :version => "~>1.0", :skip => true},
  {:name => "xml-simple", :version => "~>1.0", :skip => true}
]
