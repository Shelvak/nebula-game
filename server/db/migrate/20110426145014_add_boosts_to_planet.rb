class AddBoostsToPlanet < ActiveRecord::Migration
  def self.up
    change_table :ss_objects do |t|
      %w{metal energy zetium}.each do |resource|
        %w{rate storage}.each do |attr|
          t.datetime "#{resource}_#{attr}_boost_ends_at"
        end
      end
    end

    change_table :cred_stats do |t|
      t.string :resource, :limit => 6
      t.string :attribute, :limit => 7
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end