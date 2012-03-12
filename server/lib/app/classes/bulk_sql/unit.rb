class BulkSql::Unit < BulkSql
  def self.save(objects); super(objects, ::Unit); end
end