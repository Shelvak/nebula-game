class SplitPlanetRatesIntoTwoParts < ActiveRecord::Migration
  def self.up
    change_table :ss_objects do |t|
      %w{metal energy zetium}.each do |resource|
        t.change resource, "float unsigned not null"
        t.rename "#{resource}_rate", "#{resource}_generation_rate"
        t.column "#{resource}_usage_rate", "float unsigned not null",
          :default => 0
      end
    end
    
    SsObject::Planet.all.each do |planet|
      [:metal, :energy, :zetium].each do |resource|
        planet.send("#{resource}_generation_rate=", 0)
        planet.send("#{resource}_usage_rate=", 0)
      end
      
      planet.buildings.each do |building|
        if building.class.manages_resources?
          [:metal, :energy, :zetium].each do |resource|
            planet.send("#{resource}_generation_rate=", 
              planet.send("#{resource}_generation_rate") + 
              building.send("#{resource}_generation_rate")
            )
            planet.send("#{resource}_usage_rate=", 
              planet.send("#{resource}_usage_rate") + 
              building.send("#{resource}_usage_rate")
            )
          end
        end
      end
      
      planet.save!
    end
    
    change_table :ss_objects do |t|
      %w{metal energy zetium}.each do |resource|
        t.change "#{resource}_generation_rate", "float unsigned not null"
      end
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end