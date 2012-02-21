class StripDownUnnecessarryRouteFields < ActiveRecord::Migration
  def self.up
    change_table :routes do |t|
      %w{source current target}.each do |side|
        %w{name variation solar_system_id}.each do |attr|
          t.remove :"#{side}_#{attr}"
        end
      end
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end