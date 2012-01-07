class AddCreatedAtToPlayer < ActiveRecord::Migration
  def self.up
    add_column :players, :created_at, :datetime, :null => false
    Galaxy.all.each do |galaxy|
      galaxy.players.update_all ["created_at=?", galaxy.created_at]
    end
  end

  def self.down
    remove_column :players, :created_at
  end
end