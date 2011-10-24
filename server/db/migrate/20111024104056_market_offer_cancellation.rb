class MarketOfferCancellation < ActiveRecord::Migration
  def self.up
    change_table :market_offers do |t|
      t.change :to_rate, 'double unsigned', :null => false
      t.column :cancellation_shift, 'double', :null => false
      t.column :cancellation_amount, 'int(9) unsigned', :null => false
      t.column :cancellation_total_amount, 'int(9) unsigned', :null => false
    end

    change_table :market_rates do |t|
      t.change :to_rate, 'double unsigned', :null => false
    end
  end

  def self.down
    change_table :market_offers do |t|
      t.remove :cancellation_shift
      t.remove :cancellation_amount
      t.remove :cancellation_total_amount
    end

    change_table :market_rates do |t|
      t.change :to_rate, 'float', :null => false
    end
  end
end