class CreatePlayerOptions < ActiveRecord::Migration
  def self.up
    create_table :player_options, :id => false do |t|
      t.belongs_to :player, :null => false
      t.column :data, :blob, :null => false
    end

    execute("ALTER TABLE `player_options` ADD PRIMARY KEY (`player_id`)")
    add_fk :players, :player_options
  end

  def self.down
    drop_table :player_options
  end
end