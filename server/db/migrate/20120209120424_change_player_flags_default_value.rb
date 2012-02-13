class ChangePlayerFlagsDefaultValue < ActiveRecord::Migration
  def self.up
    change_column :players, :flags, 'tinyint(2) unsigned', :default => 0,
      :null => false
  end

  def self.down
    change_column :players, :flags, 'tinyint(2) unsigned', :default => 1,
      :null => false
  end
end