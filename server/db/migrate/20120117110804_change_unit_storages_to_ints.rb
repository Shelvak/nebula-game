class ChangeUnitStoragesToInts < ActiveRecord::Migration
  def self.up
    %w{metal energy zetium}.each do |resource|
      change_column :units, resource, 'int unsigned', :null => false,
                    :default => 0
    end
  end

  def self.down
    %w{metal energy zetium}.each do |resource|
      change_column :units, resource, :float, :null => false, :default => 0
    end
  end
end