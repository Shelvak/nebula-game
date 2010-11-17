class AddRouteFks < ActiveRecord::Migration
  def self.up
    c = ActiveRecord::Base.connection
    c.execute "ALTER TABLE `units` ADD FOREIGN KEY (`route_id`)
      REFERENCES `routes` (`id`) ON DELETE SET NULL"
  end

  def self.down
    raise IrreversibleMigration
  end
end