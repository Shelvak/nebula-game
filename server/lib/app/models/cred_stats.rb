class CredStats < ActiveRecord::Base
  # Accelerate an upgradable
  ACTION_ACCELERATE = 0
  # Self-destruct a building
  ACTION_SELF_DESTRUCT = 1
  # Move a building
  ACTION_MOVE = 2
  # Boost resource extraction/storage.
  ACTION_BOOST = 3
  # Change alliance data.
  ACTION_ALLIANCE_CHANGE = 4
  # Speed up movement.
  ACTION_MOVEMENT_SPEED_UP = 5
  # Buy VIP
  ACTION_VIP = 6
  # Finish exploration
  ACTION_FINISH_EXPLORATION = 7
  # Remove foliage
  ACTION_REMOVE_FOLIAGE = 8
  # Buy NPC or system offer from market.
  ACTION_BUY_OFFER = 9
  # Pay market fee with creds.
  ACTION_MARKET_FEE = 10
  # Unlearn technology
  ACTION_UNLEARN_TECHNOLOGY = 11

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
      player, ACTION_BOOST, Cfg.planet_boost_cost,
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
  
  def self.remove_foliage(player, width, height)
    new_record(
      player, ACTION_REMOVE_FOLIAGE,
      Cfg.foliage_removal_cost(width, height)
    )
  end
  
  def self.buy_offer(player, cost)
    new_record(player, ACTION_BUY_OFFER, cost)
  end
  
  def self.market_fee(player, cost)
    new_record(player, ACTION_MARKET_FEE, cost)
  end

  def self.unlearn_technology(player, cost)
    new_record(player, ACTION_UNLEARN_TECHNOLOGY, cost)
  end
end