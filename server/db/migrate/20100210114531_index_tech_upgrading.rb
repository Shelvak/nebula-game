class IndexTechUpgrading < ActiveRecord::Migration
  def self.up
    add_index :technologies, [:player_id, :upgrade_ends_at],
      :name => 'upgrading'
  end

  def self.down
    raise IrreversibleMigration
  end
end