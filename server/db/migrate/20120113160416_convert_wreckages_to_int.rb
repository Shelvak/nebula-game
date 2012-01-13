class ConvertWreckagesToInt < ActiveRecord::Migration
  def self.up
    %w{metal energy zetium}.each do |resource|
      change_column :wreckages, resource, 'int unsigned', :null => false,
        :default => 0
    end
    change_column :wreckages, :galaxy_id, :integer, :null => false
  end

  def self.down
    %w{metal energy zetium}.each do |resource|
      change_column :wreckages, resource, :float, :null => false,
        :default => 0
    end
    change_column :wreckages, :galaxy_id, :integer, :null => true
  end
end