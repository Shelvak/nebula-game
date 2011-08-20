unless rake?
  ActiveRecord::Base.establish_connection(USED_DB_CONFIG)
  ActiveRecord::Base.connection.execute "SET NAMES UTF8"
end