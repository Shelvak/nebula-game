class CreateCallbacks < ActiveRecord::Migration
  def self.up
    create_table :callbacks, :id => false do |t|
      t.string :class, :limit => 50, :null => false
      t.column :object_id, 'int unsigned not null'
      t.datetime :ends_at, :null => false
    end

    add_index :callbacks, :ends_at, :name => 'tick'
    add_index :callbacks, [:class, :object_id], :name => 'removal'
  end

  def self.down
    raise IrreversibleMigration
  end
end