class CredStats < ActiveRecord::Base
  # Accelerate an upgradable
  ACTION_ACCELERATE = 0
  # Self-destruct a building
  ACTION_SELF_DESTRUCT = 1
  # Move a building
  ACTION_MOVE = 2
  # Boost resource extraction.
  ACTION_BOOST = 3
  # Change alliance data.
  ACTION_ALLIANCE_CHANGE = 4
  # Speed up movement.
  ACTION_MOVEMENT_SPEED_UP = 5
  # Buy VIP
  ACTION_VIP = 6

  def self.insert(attributes)
    attributes[:created_at] = Time.now
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

  def self.self_destruct!(model)
    player = model.player
    insert(
      :action => ACTION_SELF_DESTRUCT,
      :player_id => player.id,
      :creds_left => player.creds,
      :class_name => model.class.to_s,
      :level => model.level,
      :cost => CONFIG['creds.building.destroy']
    )
  end

  def self.move!(model)
    player = model.player
    insert(
      :action => ACTION_MOVE,
      :player_id => player.id,
      :creds_left => player.creds,
      :class_name => model.class.to_s,
      :level => model.level,
      :cost => CONFIG['creds.building.move']
    )
  end

  def self.alliance_change!(player)
    insert(
      :action => ACTION_ALLIANCE_CHANGE,
      :player_id => player.id,
      :creds_left => player.creds,
      :cost => CONFIG['creds.alliance.change']
    )
  end

  def self.movement_speed_up!(player, cost)
    insert(
      :action => ACTION_MOVEMENT_SPEED_UP,
      :player_id => player.id,
      :creds_left => player.creds,
      :cost => cost
    )
  end

  def self.vip!(player, cost)
    insert(
      :action => ACTION_VIP,
      :player_id => player.id,
      :creds_left => player.creds,
      :cost => cost
    )
  end

  def self.boost!(player, resource, attribute)
    insert(
      :action => ACTION_BOOST,
      :player_id => player.id,
      :creds_left => player.creds,
      :resource => resource,
      :attribute => attribute,
      :cost => CONFIG['creds.planet.resources.boost.cost']
    )
  end
end