class CreateQuest < ActiveRecord::Migration
  def self.up
    create_table :quests do |t|
      t.belongs_to :parent
      t.text :rewards, :null => false
      t.string :help_url_id, :length => 50
      t.text :text, :null => false
    end

    add_index :quests, :parent_id, :name => "child quests"
    c = ActiveRecord::Base.connection
    c.execute "ALTER TABLE `quests` ADD FOREIGN KEY (
      `parent_id`) REFERENCES `quests` (`id`) ON DELETE CASCADE"
  end

  def self.down
    drop_table :quests
  end
end