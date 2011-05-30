unless rake?
  ActiveRecord::Base.establish_connection(USED_DB_CONFIG)
  ActiveRecord::Base.connection.execute "SET NAMES UTF8"
end

## Preloader - for traits and other advanced technology to function correctly
## buildings, units and technologies must be preloaded.
##
## This must be ran after config.
benchmark :server_preloader do
  Dir[
    File.join(ROOT_DIR, 'lib', 'app', 'models',
      '{building,unit,technology}', '*.rb')
  ].each { |file| require file }
end