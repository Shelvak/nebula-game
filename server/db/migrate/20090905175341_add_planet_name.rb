class AddPlanetName < ActiveRecord::Migration
  def self.up
    change_table :planets do |t|
      t.string :name, :null => false, :default => ""
    end

    ActiveRecord::Base.connection.execute(
      'UPDATE `planets` SET `name`=CONCAT("G", galaxy_id, "-S", solar_system_id, "-P", id) ' +
        "WHERE `name`=''"
    )
  end

  def self.down
    raise IrreversibleMigration
  end
end