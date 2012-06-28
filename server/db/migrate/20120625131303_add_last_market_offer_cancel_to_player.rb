class AddLastMarketOfferCancelToPlayer < ActiveRecord::Migration
  def self.up
    add_column :players, :last_market_offer_cancel, :datetime, null: false,
      default: "0000-01-01 00:00:00"
  end

  def self.down
    remove_column :players, :last_market_offer_cancel
  end
end
