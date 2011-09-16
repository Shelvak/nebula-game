class CreateMarketRate < ActiveRecord::Migration
  def self.up
    create_table :market_rates do |t|
      t.belongs_to :galaxy, :null => false
      t.column :from_kind, 'tinyint(2) unsigned', :null => false
      t.column :to_kind, 'tinyint(2) unsigned', :null => false
      t.column :from_amount, 'int(10) unsigned', :null => false
      t.float :to_rate, :null => false
    end

    add_index :market_rates, [:galaxy_id, :from_kind, :to_kind],
              :name => "lookup"
    add_fk :galaxies, :market_rates
  end

  def self.down
    drop_table :market_rates
  end
end