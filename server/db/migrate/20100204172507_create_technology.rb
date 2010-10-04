class CreateTechnology < ActiveRecord::Migration
  def self.up
    create_table :technologies do |t|
      t.datetime :last_update, :upgrade_ends_at
      t.column :pause_remainder, 'int unsigned null'
      t.integer :scientists, :default => 0
      t.column :level, 'tinyint(2) unsigned not null'
      t.column :player_id, 'int unsigned not null'
      t.string :type, :limit => 50
    end

    add_index :technologies, [:player_id, :type, :level],
      :name => 'main', :unique => true
  end

  def self.down
    drop_table :technologies
  end
end