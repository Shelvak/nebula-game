class CreateSolarSystem < ActiveRecord::Migration
  def self.up
    create_table :solar_systems do |t|
      t.string :type, :null => false
      t.belongs_to :galaxy, :null => false
      t.integer :x, :y, :null => false, :limit => 3
      t.column :variation, 'tinyint(2) not null'
    end
  end

  def self.down
    drop_table :solar_systems
  end
end