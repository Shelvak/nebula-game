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

  def self.insert(player, attributes)
    attributes[:created_at] = Time.now
    attributes[:player_id] = player.id
    attributes[:creds_left] = player.creds
    attributes[:vip_level] = player.vip_level
    attributes[:vip_creds] = player.vip_creds

    connection.execute("INSERT INTO `cred_stats` SET #{
      sanitize_sql_hash_for_assignment(attributes)}")
  end

  # Registers upgradable part acceleration.
  def self.accelerate!(model, cost, time, seconds_reduced)
    insert(
      model.player,
      :action => ACTION_ACCELERATE,
      :class_name => model.class.to_s,
      :level => model.level,
      :cost => cost,
      :time => time,
      :actual_time => seconds_reduced
    )
  end

  def self.self_destruct!(model)
    insert(
      model.player,
      :action => ACTION_SELF_DESTRUCT,
      :class_name => model.class.to_s,
      :level => model.level,
      :cost => CONFIG['creds.building.destroy']
    )
  end

  def self.move!(model)
    insert(
      model.player,
      :action => ACTION_MOVE,
      :class_name => model.class.to_s,
      :level => model.level,
      :cost => CONFIG['creds.building.move']
    )
  end

  def self.alliance_change!(player)
    insert(
      player,
      :action => ACTION_ALLIANCE_CHANGE,
      :cost => CONFIG['creds.alliance.change']
    )
  end

  def self.movement_speed_up!(player, cost)
    insert(
      player,
      :action => ACTION_MOVEMENT_SPEED_UP,
      :cost => cost
    )
  end

  def self.vip!(player, level, cost)
    insert(
      player,
      :action => ACTION_VIP,
      :level => level,
      :cost => cost
    )
  end

  def self.boost!(player, resource, attribute)
    insert(
      player,
      :action => ACTION_BOOST,
      :resource => resource,
      :attribute => attribute,
      :cost => CONFIG['creds.planet.resources.boost.cost']
    )
  end
end