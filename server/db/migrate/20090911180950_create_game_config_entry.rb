class CreateGameConfigEntry < ActiveRecord::Migration
  def self.up
    create_table :config_entries, :id => false do |t|
      t.string :key, :null => false
      t.integer :galaxy_id, :null => false
      t.boolean :string, :null => false
      t.string :string_value
      t.integer :int_value
    end

    add_index :config_entries, [:key, :galaxy_id], :unique => true, :name => 'main'
  end

  def self.down
    raise IrreversibleMigration
  end
end