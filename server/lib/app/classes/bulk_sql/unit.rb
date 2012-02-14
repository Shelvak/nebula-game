class BulkSql::Unit < BulkSql
  @mutex = Mutex.new

  def self.save(objects); super(objects, ::Unit); end
end