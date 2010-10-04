class CreateObjectiveProgress < ActiveRecord::Migration
  def self.up
    create_table :objective_progresses do |t|
      t.belongs_to :objective
      t.belongs_to :player
      t.column :completed, 'tinyint(2) unsigned not null default 0'
    end

    add_index :objective_progresses, :objective_id,
      :name => "objective_fk"
    add_index :objective_progresses, :player_id,
      :name => "player_fk"
    c = ActiveRecord::Base.connection
    c.execute "ALTER TABLE `objective_progresses` ADD FOREIGN KEY (
      `objective_id`) REFERENCES `objectives` (`id`) ON DELETE CASCADE"
    c.execute "ALTER TABLE `objective_progresses` ADD FOREIGN KEY (
      `player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE"
  end

  def self.down
    drop_table :objective_progresses
  end
end