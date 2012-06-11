class BulkSql::QuestProgress < BulkSql
  def self.save(objects)
    super(objects, ::QuestProgress, assign_pks: false, run_callbacks: false)
  end
end