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
  # Finish exploration
  ACTION_FINISH_EXPLORATION = 7

  # Creates a new record which you can save later.
  def self.new_record(player, action, cost, attributes={})
    attributes[:action] = action
    attributes[:created_at] = Time.now
    attributes[:cost] = cost
    attributes[:player_id] = player.id
    attributes[:creds] = player.creds
    attributes[:free_creds] = player.free_creds
    attributes[:vip_level] = player.vip_level
    attributes[:vip_creds] = player.vip_creds
    
    new(attributes)
  end

  # Registers upgradable part acceleration.
  def self.accelerate(model, cost, time, seconds_reduced)
    new_record(
      model.player, ACTION_ACCELERATE, cost,
      :class_name => model.class.to_s,
      :level => model.level,
      :time => time,
      :actual_time => seconds_reduced
    )
  end

  def self.self_destruct(model)
    new_record(
      model.player, ACTION_SELF_DESTRUCT, CONFIG['creds.building.destroy'],
      :class_name => model.class.to_s,
      :level => model.level
    )
  end

  def self.move(model)
    new_record(
      model.player, ACTION_MOVE, CONFIG['creds.building.move'],
      :class_name => model.class.to_s,
      :level => model.level
    )
  end

  def self.alliance_change(player)
    new_record(
      player, ACTION_ALLIANCE_CHANGE, CONFIG['creds.alliance.change']
    )
  end

  def self.movement_speed_up(player, cost)
    new_record(
      player, ACTION_MOVEMENT_SPEED_UP, cost
    )
  end

  def self.vip(player, level, cost)
    new_record(
      player, ACTION_VIP, cost,
      :level => level
    )
  end

  def self.boost(player, resource, attribute)
    new_record(
      player, ACTION_BOOST, CONFIG['creds.planet.resources.boost.cost'],
      :resource => resource.to_s,
      :attr => attribute.to_s
    )
  end
  
  def self.finish_exploration(player, width, height)
    new_record(
      player, ACTION_FINISH_EXPLORATION,
      Cfg.exploration_finish_cost(width, height)
    )
  end
end