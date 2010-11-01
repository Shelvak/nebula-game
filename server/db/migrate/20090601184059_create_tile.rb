class CreateTile < ActiveRecord::Migration
  def self.up
    create_table :tiles do |t|
      t.column :kind, 'tinyint(1) unsigned NOT NULL'
      t.column :planet_id, 'int unsigned NOT NULL'
      t.column :x, 'tinyint(1) unsigned NOT NULL'
      t.column :y, 'tinyint(1) unsigned NOT NULL'
    end
  end

  def self.down
    drop_table :tiles
  end
end