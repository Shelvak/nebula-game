class ReduceBinaryFlagsInPlayer < ActiveRecord::Migration
  def self.up
    change_table :players do |t|
      t.rename :first_time, :flags
      t.change :flags, "tinyint(2) unsigned", :null => false, :default => 1
    end
    connection.execute(
      "UPDATE `players` SET `flags`=IF(`vip_free` = 1, `flags` | 2, `flags`)"
    )
    change_table :players do |t|
      t.remove :vip_free
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end