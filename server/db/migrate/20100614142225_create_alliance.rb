class CreateAlliance < ActiveRecord::Migration
  def self.up
    create_table :alliances do |t|
      t.string :name, :null => false
      t.column :nap_alliance_id, 'int unsigned'
    end
  end

  def self.down
    drop_table :alliances
  end
end