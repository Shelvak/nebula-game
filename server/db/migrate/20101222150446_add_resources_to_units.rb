class AddResourcesToUnits < ActiveRecord::Migration
  def self.up
    change_table :units do |t|
      %w{metal energy zetium}.each do |resource|
        t.column resource, "float not null", :default => 0
      end
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end