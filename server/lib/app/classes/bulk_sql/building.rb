class BulkSql::Building < BulkSql
  @mutex = Mutex.new

  def self.save(objects); super(objects, ::Building); end
end