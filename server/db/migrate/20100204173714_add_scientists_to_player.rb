class AddScientistsToPlayer < ActiveRecord::Migration
  def self.up
    change_table :players do |t|
      t.column :scientists, 'int unsigned not null default 0'
      t.column :scientists_max, 'int unsigned not null default 0'
    end

    Player.all.each do |player|
      scientists = 0
      Building::ResearchCenter.of_player(player).each do |rc|
        scientists += rc.scientists
      end
      player.scientists = player.scientists_max = scientists
      player.save!
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end