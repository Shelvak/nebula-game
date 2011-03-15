class ActiveRecord::Migration
  def self.foreign_key(parent_table, child_table, parent_key=:id,
      child_key=nil, action="CASCADE")
    child_key ||= parent_table.to_s.singularize + "_id"

    ActiveRecord::Base.connection.execute "ALTER TABLE `#{child_table
      }` ADD FOREIGN KEY (`#{child_key}`) REFERENCES `#{parent_table}` (`#{
      parent_key}`) ON DELETE #{action}"
  end
end