class CreateNap < ActiveRecord::Migration
  def self.up
    create_table :naps do |t|
      t.column :initiator_id, 'int unsigned not null'
      t.column :acceptor_id, 'int unsigned not null'
      t.column :status, "tinyint(2) unsigned not null DEFAULT #{
        Nap::STATUS_PROPOSED}"
      t.datetime :created_at, :null => false
      t.datetime :expires_at
    end

    change_table :naps do |t|
      t.index [:initiator_id, :acceptor_id], :unique => true,
        :name => "enforce_one_nap_per_pair"
      t.index [:initiator_id, :status],
        :name => "lookup_naps_for_alliance_1st"
      t.index [:acceptor_id, :status],
        :name => "lookup_naps_for_alliance_2nd"
    end
  end

  def self.down
    drop_table :naps
  end
end