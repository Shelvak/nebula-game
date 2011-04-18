class AddLanguageToPlayer < ActiveRecord::Migration
  def self.up
    change_table :players do |t|
      t.column :language, 'char(2) not null', :default => "en"
    end
  end

  def self.down
    raise IrreversibleMigration
  end
end