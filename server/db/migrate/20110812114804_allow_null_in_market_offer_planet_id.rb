class AllowNullInMarketOfferPlanetId < ActiveRecord::Migration
  def self.up
    change_table :market_offers do |t|
      t.change :planet_id, :int, :null => true
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end