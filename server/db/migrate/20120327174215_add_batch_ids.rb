class AddBatchIds < ActiveRecord::Migration
  def self.up
    %w{solar_systems ss_objects buildings units fow_ss_entries players}.each do
      |table|
      
      execute(%Q{
        ALTER TABLE `#{table}`
        ADD `batch_id` varchar(50),
        ADD INDEX `batch_id` (`batch_id`)
      })
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end