class BulkSql::ObjectiveProgress < BulkSql
  def self.save(objects)
    super(objects, ::ObjectiveProgress, assign_pks: false, run_callbacks: false)
  end
end