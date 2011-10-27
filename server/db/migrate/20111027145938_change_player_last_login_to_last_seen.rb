class ChangePlayerLastLoginToLastSeen < ActiveRecord::Migration
  def self.up
    rename_column :players, :last_login, :last_seen
  end

  def self.down
    rename_column :players, :last_seen, :last_login
  end
end