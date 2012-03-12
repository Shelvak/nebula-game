class BulkSql::FowSsEntry < BulkSql
  def self.save(objects); super(objects, ::FowSsEntry); end
end