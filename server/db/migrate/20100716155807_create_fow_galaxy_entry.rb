class CreateFowGalaxyEntry < ActiveRecord::Migration
  def self.up
    create_table :fow_galaxy_entries do |t|
      t.belongs_to :galaxy, :null => false
      t.belongs_to :player
      t.belongs_to :alliance

      %w{x y x_end y_end}.each do |attr|
        t.column attr, 'int not null'
      end

      t.column :counter, 'tinyint(2) unsigned not null default 1'
    end

    add_index :fow_galaxy_entries, [:galaxy_id, :x, :x_end, :y, :y_end],
      :name => 'lookup_players_by_coords'
    add_index :fow_galaxy_entries, [:player_id, :x, :y, :x_end, :y_end],
      :name => "player_visiblity", :unique => true
    add_index :fow_galaxy_entries, [:alliance_id, :x, :y, :x_end, :y_end],
      :name => "alliance_visiblity", :unique => true

    c = ActiveRecord::Base.connection
    c.execute "ALTER TABLE `fow_galaxy_entries` ADD FOREIGN KEY (
      `galaxy_id`) REFERENCES `galaxies` (`id`) ON DELETE CASCADE"
  end

  def self.down
    drop_table :fow_galaxy_entries
  end
end