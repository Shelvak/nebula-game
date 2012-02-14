class BulkSql::FowSsEntry < BulkSql
  @mutex = Mutex.new

  def self.save(objects); super(objects, ::FowSsEntry); end
end