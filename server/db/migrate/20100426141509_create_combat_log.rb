class CreateCombatLog < ActiveRecord::Migration
  def self.up
    create_table :combat_logs, :id => false do |t|
      t.column :sha1_id, 'char(40) not null'
      t.column :info, 'text not null'
      t.datetime :expires_at, :null => false
    end

    ActiveRecord::Base.connection.execute(
      "ALTER TABLE `combat_logs` ADD PRIMARY KEY ( `sha1_id` ) "
    )
    add_index :combat_logs, :expires_at
  end

  def self.down
    drop_table :combat_logs
  end
end