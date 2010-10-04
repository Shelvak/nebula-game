class IndexCounterOnFow < ActiveRecord::Migration
  def self.up
    add_index :fow_ss_entries, :counter, :name => "for_cleanup"
    add_index :fow_galaxy_entries, :counter, :name => "for_cleanup"
  end

  def self.down
    raise IrreversibleMigration
  end
end