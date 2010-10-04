class ChangeRouteLocationAttrs < ActiveRecord::Migration
  def self.up
    change_table :routes do |t|
      t.remove :target_x
      t.remove :target_y
      t.column :target_x, 'int(11) not null'
      t.column :target_y, 'int(11) not null'
      t.string :target_name
      t.column :target_variation, 'tinyint(2) unsigned'
      t.belongs_to :target_solar_system

      ['current', 'source'].each do |type|
        t.column :"#{type}_id", 'int(11) unsigned not null'
        t.column :"#{type}_type", 'tinyint(2) unsigned not null'
        t.column :"#{type}_x", 'int(11) not null'
        t.column :"#{type}_y", 'int(11) not null'
        t.string :"#{type}_name"
        t.column :"#{type}_variation", 'tinyint(2) unsigned'
        t.belongs_to :"#{type}_solar_system"
      end
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end