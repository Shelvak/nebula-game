class BulkSql::Building < BulkSql
  def self.save(objects); super(objects, ::Building); end
end