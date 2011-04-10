class CreateCredStat < ActiveRecord::Migration
  def self.up
    create_table :cred_stats do |t|
      t.column :action, 'tinyint(2) unsigned not null'
      t.belongs_to :player
      t.column :creds_left, 'int unsigned not null'
      t.string :class_name, :limit => 50
      t.column :level, 'tinyint(2) unsigned'
      t.column :cost, 'int unsigned not null'
      t.column :time, 'int unsigned'
      t.column :actual_time, 'int unsigned'
    end

    add_index :cred_stats, :action, :name => 'by_action'
    add_index :cred_stats, :player_id, :name => 'by_player'
    add_fk("players", "cred_stats", "SET NULL")
  end

  def self.down
    drop_table :cred_stats
  end
end