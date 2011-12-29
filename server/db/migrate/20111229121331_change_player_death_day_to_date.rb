class ChangePlayerDeathDayToDate < ActiveRecord::Migration
  def self.up
    add_column :players, :death_date, :datetime
    Galaxy.where("apocalypse_start IS NOT NULL").all.each do |galaxy|
      Player.where(:galaxy_id => galaxy.id).where("death_day IS NOT NULL").
        update_all("death_date=DATE_ADD('#{galaxy.apocalypse_start.to_s(:db)
          }', INTERVAL death_day DAY)")
    end
    remove_column :players, :death_day
  end

  def self.down
    add_column :players, :death_day, :integer
    Galaxy.where("apocalypse_start IS NOT NULL").all.each do |galaxy|
      Player.where(:galaxy_id => galaxy.id).where("death_date IS NOT NULL").
        update_all("death_day=DATEDIFF(death_date, '#{
          galaxy.apocalypse_start.to_s(:db)}')")
    end
    remove_column :players, :death_date
  end
end