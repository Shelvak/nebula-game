class AddFkToTables < ActiveRecord::Migration
  def self.fk(target_table, source_table, type="CASCADE")
    ActiveRecord::Base.connection.execute "ALTER TABLE `#{
      source_table}` ADD FOREIGN KEY (`#{
      target_table.singularize}_id`) REFERENCES `#{
      target_table}` (`id`) ON DELETE #{type}"
  end

  def self.up
    c = ActiveRecord::Base.connection

    fk("galaxies", "solar_systems")
    fk("solar_systems", "fow_ss_entries")
    remove_column :planets, :galaxy_id
    fk("solar_systems", "planets")
    c.execute "ALTER TABLE `tiles` CHANGE `planet_id`
      `planet_id` INT(11) NOT NULL"
    fk("planets", "tiles")
    fk("planets", "resources_entries")
    fk("planets", "folliages")
    fk("planets", "buildings")
    add_index :construction_queue_entries, :constructor_id,
      :name => 'foreign_key'
    c.execute "ALTER TABLE `construction_queue_entries` ADD FOREIGN KEY (
      `constructor_id`) REFERENCES `buildings` (`id`) ON DELETE CASCADE"
    fk("galaxies", "players")
    c.execute "ALTER TABLE `technologies` CHANGE `player_id`
      `player_id` INT(11) NOT NULL"
    fk("players", "technologies")
    add_index :notifications, :player_id, :name => 'foreign_key'
    fk("players", "notifications")
    fk("players", "fow_ss_entries")
    c.execute "ALTER TABLE `units` CHANGE `player_id`
      `player_id` INT(11) NULL"
    fk("players", "units", "SET NULL")
    fk("players", "planets", "SET NULL")

    add_column :alliances, :galaxy_id, :integer, :null => false
    add_index :alliances, :galaxy_id, :name => "foreign_key"
    remove_column :alliances, :nap_alliance_id
    c.execute "ALTER TABLE `fow_ss_entries` CHANGE `alliance_id`
      `alliance_id` INT(11) NULL"
    fk("galaxies", "alliances")
    fk("alliances", "fow_ss_entries")
    c.execute "ALTER TABLE `players` CHANGE `alliance_id`
      `alliance_id` INT(11) NULL"
    fk("alliances", "players", "SET NULL")

    c.execute "ALTER TABLE `naps` CHANGE `initiator_id`
      `initiator_id` INT(11) NOT NULL"
    c.execute "ALTER TABLE `naps` ADD FOREIGN KEY (
      `initiator_id`) REFERENCES `alliances` (`id`) ON DELETE CASCADE"
    c.execute "ALTER TABLE `naps` CHANGE `acceptor_id`
      `acceptor_id` INT(11) NOT NULL"
    c.execute "ALTER TABLE `naps` ADD FOREIGN KEY (
      `acceptor_id`) REFERENCES `alliances` (`id`) ON DELETE CASCADE"
    
    add_column :units, :galaxy_id, :integer, :null => false
    add_index :units, :galaxy_id, :name => "foreign_key"
    fk("galaxies", "units")
    c.execute "ALTER TABLE `units` CHANGE `route_id`
      `route_id` INT(11) NULL"

    add_column :routes, :player_id, :integer, :null => false
    add_index :routes, :player_id, :name => "foreign_key"
    fk("players", "routes")
    c.execute "ALTER TABLE `route_hops` CHANGE `route_id`
      `route_id` INT(11) NOT NULL"
    fk("routes", "route_hops")
  end

  def self.down
    raise IrreversibleMigration
  end
end