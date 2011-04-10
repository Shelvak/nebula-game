class CredStats < ActiveRecord::Base
  ACTION_ACCELERATE = 0
  ACTION_SELF_DESTRUCT = 1
  ACTION_MOVE = 2

  def self.insert(attributes)
    connection.execute("INSERT INTO `cred_stats` SET #{
      sanitize_sql_hash_for_assignment(attributes)}")
  end

  # Registers upgradable part acceleration.
  def self.accelerate!(model, cost, time, seconds_reduced)
    player = model.player
    insert(
      :action => ACTION_ACCELERATE,
      :player_id => player.id,
      :creds_left => player.creds,
      :class_name => model.class.to_s,
      :level => model.level,
      :cost => cost,
      :time => time,
      :actual_time => seconds_reduced
    )
  end

  def self.self_destruct!(model, cost)
    player = model.player
    insert(
      :action => ACTION_SELF_DESTRUCT,
      :player_id => player.id,
      :creds_left => player.creds,
      :class_name => model.class.to_s,
      :level => model.level,
      :cost => cost
    )
  end

  def self.move!(model, cost)
    player = model.player
    insert(
      :action => ACTION_MOVE,
      :player_id => player.id,
      :creds_left => player.creds,
      :class_name => model.class.to_s,
      :level => model.level,
      :cost => cost
    )
  end
end