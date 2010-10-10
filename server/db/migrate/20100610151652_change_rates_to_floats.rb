class ChangeRatesToFloats < ActiveRecord::Migration
  def self.up
    change_table :resources_entries do |t|
      [:metal, :energy, :zetium].each do |resource|
        ['', '_storage', '_rate'].each do |type|
          t.change "#{resource}#{type}",
            'FLOAT NOT NULL', :default => 0
        end
      end
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end