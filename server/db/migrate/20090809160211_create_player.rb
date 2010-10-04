class CreatePlayer < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.belongs_to :galaxy
      t.column :auth_token, 'char(64) not null'
      t.string :name, :limit => 64, :null => false
    end

    add_index :players, [:galaxy_id, :auth_token], :unique => true,
      :name => 'authentication'
  end

  def self.down
    drop_table :players
  end
end