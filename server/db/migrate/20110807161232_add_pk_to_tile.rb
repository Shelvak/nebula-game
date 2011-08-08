class AddPkToTile < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE `tiles` ADD `id` BIGINT UNSIGNED NOT NULL 
      AUTO_INCREMENT PRIMARY KEY FIRST"
  end

  def self.down
    raise IrreversibleMigration
  end
end