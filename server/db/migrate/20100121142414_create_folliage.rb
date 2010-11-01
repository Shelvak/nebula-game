class CreateFolliage < ActiveRecord::Migration
  def self.up
    create_table :folliages, :id => false do |t|
      t.belongs_to :planet, :null => false
      t.integer :x, :y, :variation, :null => false
    end

    add_index :folliages, [:planet_id, :x, :y], :name => 'coords',
      :unique => true
  end

  def self.down
    drop_table :folliages
  end
end