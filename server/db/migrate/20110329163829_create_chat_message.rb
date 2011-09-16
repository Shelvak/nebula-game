class CreateChatMessage < ActiveRecord::Migration
  def self.up
    create_table :chat_messages, :id => false do |t|
      t.belongs_to :source, :null => false
      t.belongs_to :target, :null => false
      t.string :message, :limit => 255, :null => false
      t.datetime :created_at, :null => false
    end

    add_index :chat_messages, :source_id
    add_index :chat_messages, :target_id
    add_fk("players", "chat_messages", :target_key => "source_id")
    add_fk("players", "chat_messages", :target_key => "target_id")
  end

  def self.down
    raise IrreversibleMigration
  end
end