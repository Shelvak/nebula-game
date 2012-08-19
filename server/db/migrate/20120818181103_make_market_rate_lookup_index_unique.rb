class MakeMarketRateLookupIndexUnique < ActiveRecord::Migration
  def self.up
    execute(
      "ALTER TABLE `market_rates`
        DROP INDEX `lookup`,
        ADD UNIQUE `lookup` ( `galaxy_id` , `from_kind` , `to_kind` )
      "
    )
  end

  def self.down
    execute(
      "ALTER TABLE `market_rates`
        DROP INDEX `lookup`,
        ADD INDEX `lookup` ( `galaxy_id` , `from_kind` , `to_kind` )
      "
    )
  end
end