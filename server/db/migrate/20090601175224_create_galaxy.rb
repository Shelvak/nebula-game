class CreateGalaxy < ActiveRecord::Migration
  def self.up
    create_table :galaxies do |t|
      t.datetime :created_at, :null => false
    end
  end

  def self.down
    drop_table :galaxies
  end
end