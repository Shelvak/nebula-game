class AddSizeToPlanet < ActiveRecord::Migration
  def self.up
    change_table :planets do |t|
      t.string :size, :null => false, :default => 0
    end

    from = CONFIG['planet.size.from']
    to = CONFIG['planet.size.to']
    
    ActiveRecord::Base.connection.execute(
      "UPDATE `planets` SET `size`=FLOOR(#{from} + RAND() * #{to - from}) " +
        "WHERE `size`=0"
    )
  end

  def self.down
    raise IrreversibleMigration
  end
end