class ChangeCallbackIndexes < ActiveRecord::Migration
  def self.up
    change_table :callbacks do |t|
      t.remove_index :name => :index_callbacks_on_class_and_object_id
      t.index [:class, :object_id, :event], :name => "main",
        :unique => true
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end