class CreateMarketOffer < ActiveRecord::Migration
  def self.up
    create_table :market_offers do |t|
      t.belongs_to :galaxy, :null => false
      t.belongs_to :planet, :null => false
      t.column :from_kind, 'tinyint(2) unsigned not null'
      t.column :from_amount, 'int unsigned not null'
      t.column :to_kind, 'tinyint(2) unsigned not null'
      t.column :to_rate, 'float unsigned not null'
      t.datetime :created_at, :null => false
    end
    
    add_index(:market_offers, :galaxy_id, :name => "galaxy foreign key")
    add_index(:market_offers, :planet_id, :name => "planet foreign key")
    add_index(:market_offers, [:from_kind, :to_kind], 
      :name => "avg. market value")
    add_fk(:galaxies, :market_offers)
    add_fk(:ss_objects, :market_offers, nil, nil, "planet_id")
  end

  def self.down
    drop_table :market_offers
  end
end