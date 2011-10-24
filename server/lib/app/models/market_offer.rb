# Offer in a galaxy market that allows players to trade with each other.
#
# Offers belong to planets, so if planet owner changes, that means that
# offer owner also changes.
# 
# Some of the attributes:
# - to_rate (Float): how much of _to_kind_ resource you want for 1 of 
# _from_kind_ resource.
# - cancellation_shift (Float): how much should we shift MarketRate for this
# resource pair when cancelling this offer.
# - cancellation_amount (Fixnum): _from_amount_ when this offer was created.
# - cancellation_total_amount (Fixnum): amount of _from_kind_ resource at the time
# of this offers creation (without the amount of this offer).
#
class MarketOffer < ActiveRecord::Base
  belongs_to :galaxy
  belongs_to :planet, :class_name => "SsObject::Planet"
  delegate :player, :player_id, :to => :planet
  
  KIND_METAL = 0
  KIND_ENERGY = 1
  KIND_ZETIUM = 2
  KIND_CREDS = 3
  
  # Maps resource kind to callback manager event kind.
  CALLBACK_MAPPINGS = {
    KIND_METAL => CallbackManager::EVENT_CREATE_METAL_SYSTEM_OFFER,
    KIND_ENERGY => CallbackManager::EVENT_CREATE_ENERGY_SYSTEM_OFFER,
    KIND_ZETIUM => CallbackManager::EVENT_CREATE_ZETIUM_SYSTEM_OFFER,
  }
  
  # Maps callback manager event kind to resource kind.
  CALLBACK_MAPPINGS_FLIPPED = CALLBACK_MAPPINGS.flip
  
  validate :on => :create do
    min_amount = Cfg.market_offer_min_amount
    errors.add(:from_amount, 
      "cannot be less than minimal #{min_amount}, however #{from_amount
      } was offered.") if from_amount < min_amount
    # System offers do not belong to player, so there is no limit.
    errors.add(:base, "Maximum number of market offers reached!") \
      if ! system? && 
      player.market_offers.size >= Cfg.market_offers_max
  end
  
  before_create do
    self.galaxy_id ||= player.galaxy_id
    avg_rate = MarketRate.average(galaxy_id, from_kind, to_kind)
    offset = Cfg.market_rate_offset
    
    low = avg_rate * (1 - offset)
    high = avg_rate * (1 + offset)
    if to_rate < low 
      self.to_rate = low
    elsif to_rate > high
      self.to_rate = high
    end
    
    true
  end

  before_create do
    model = MarketRate.get(galaxy_id, from_kind, to_kind)
    old_rate = model.to_rate
    self.cancellation_amount = from_amount
    self.cancellation_total_amount = model.from_amount
    model = MarketRate.add(galaxy_id, from_kind, to_kind, from_amount, to_rate)
    self.cancellation_shift = (model.to_rate - old_rate) * -1

    true
  end

  after_destroy do
    MarketRate.subtract(
      galaxy_id, from_kind, to_kind, from_amount, cancellation_shift,
      cancellation_amount, cancellation_total_amount
    )
  end

  # Is this offer created by system?
  def system?; planet_id.nil?; end
  
  # Returns JSON hash for this +MarketOffer+.
  #
  # {
  #   'id' => Fixnum,
  #   'player' => Player#minimal | nil,
  #   'from_kind' => Fixnum,
  #   'from_amount' => Fixnum,
  #   'to_kind' => Fixnum,
  #   'to_rate' => Float,
  #   'created_at' => Time,
  # }
  #
  def as_json(options=nil)
    {
      'id' => id,
      'player' => system? ? nil : Player.minimal(player_id),
      'from_kind' => from_kind,
      'from_amount' => from_amount,
      'to_kind' => to_kind,
      'to_rate' => to_rate,
      'created_at' => created_at
    }
  end
  
  # Buys _amount_ of _source_kind_ from this +Offer+ to _buyer_planet_.
  #
  # Returns _amount_ actually bought.
  def buy!(buyer_planet, amount)
    raise GameLogicError.new("Cannot buy 0 or less! Wanted: #{amount}") \
      if amount <= 0
    amount = from_amount if amount > from_amount
        
    cost = (amount * to_rate).ceil
    buyer_source, bs_attr = self.class.resolve_kind(buyer_planet, to_kind)
    buyer_target, bt_attr = self.class.resolve_kind(buyer_planet, from_kind)
    if system?
      seller_target = nil
    else
      seller_target, _ = self.class.resolve_kind(planet, to_kind)
    end
    
    stats = CredStats.buy_offer(buyer_planet.player, cost) \
      if seller_target.nil? && to_kind == KIND_CREDS
    
    buyer_has = buyer_source.send(bs_attr)
    raise GameLogicError.new("Not enough funds for #{buyer_source
      }! Wanted #{cost} #{bs_attr} but it only had #{buyer_has}."
    ) if buyer_has < cost
    
    # Used to determine whether to send notification or not.
    original_amount = from_amount
    
    # Subtract resource that buyer is paying with from him.
    buyer_source.send(:"#{bs_attr}=", buyer_has - cost)
    # Add resource that buyer has bought from seller.
    buyer_target.send(:"#{bt_attr}=", 
      buyer_target.send(bt_attr) + amount)
    # Add resource that buyer is paying with to seller. Unless:
    # * its a system offer
    # * or #to_kind is creds and planet currently does not have an owner
    seller_target.send(
      :"#{bs_attr}=", seller_target.send(bs_attr) + cost
    ) unless seller_target.nil?
    # Reduce bought amount from offer.
    self.from_amount -= amount
    
    transaction do
      objects = [buyer_source, buyer_target]
      # We might not have seller target. See above.
      objects.push seller_target unless seller_target.nil?
      objects.uniq.each { |obj| self.class.save_obj_with_event(obj) }
      
      if from_amount == 0
        # Schedule creation of new system offer. 
        CallbackManager.register(galaxy, CALLBACK_MAPPINGS[from_kind],
          Cfg.market_bot_random_resource_cooldown_date) if system?
        destroy!
      else
        save!
      end
      percentage_bought = amount.to_f / original_amount

      MarketRate.subtract_amount(galaxy_id, from_kind, to_kind, amount)

      # Create notification if:
      # * It's not a system notification
      # * Enough of the percentage was bought
      # * Sellers planet currently has a player.
      Notification.create_for_market_offer_bought(
        self, buyer_planet.player, amount, cost
      ) if ! system? &&  
        percentage_bought >= CONFIG['market.buy.notification.threshold'] &&
        ! planet.player_id.nil?
      
      stats.save! unless stats.nil?
    end
    
    amount
  end
  
  # Cancels offer. Returns #from_amount which is left to seller.
  def cancel!
    seller_source, attr = self.class.resolve_kind(self.planet, from_kind)
    seller_source.send(:"#{attr}=", seller_source.send(attr) + from_amount)
    self.class.save_obj_with_event(seller_source)
    destroy!
  end
  
  # Resolves _kind_ into _source_ (+SsObject::Planet+ or +Player+ and 
  # _attr_ (_metal_, _energy_, _zetium_ or _creds_).
  def self.resolve_kind(source, kind)
    case kind
    when KIND_METAL then attr = :metal
    when KIND_ENERGY then attr = :energy
    when KIND_ZETIUM then attr = :zetium
    when KIND_CREDS then source = source.player; attr = :market_creds
    end
    
    [source, attr]
  end
  
  # Returns Array of #as_json type Hashes by given _conditions_. Does it 
  # swiftly!
  def self.fast_offers(*conditions)
    t = "`#{table_name}`"
    p = "`#{Player.table_name}`"
    sso = "`#{SsObject.table_name}`"
    
    (conditions.blank? ? self : where(*conditions)).
      joins("LEFT JOIN #{sso} ON #{sso}.`id` = #{t}.`planet_id` AND #{
        sso}.`type` = '#{SsObject::Planet.to_s.demodulize}'").
      joins("LEFT JOIN #{p} ON #{p}.`id` = #{sso}.`player_id`").
      select("#{t}.id, #{t}.from_kind, #{t}.from_amount, #{t}.to_kind, 
        #{t}.to_rate, #{t}.created_at, #{p}.id as player_id, 
        #{p}.name as player_name").
      c_select_all.map \
    do |row|
      player_id = row.delete "player_id"
      player_name = row.delete "player_name"
      row["player"] = player_id.nil? \
        ? nil : {"id" => player_id, "name" => player_name}
      
      # JRuby compatibility
      row["to_rate"] = row["to_rate"].to_f if row['to_rate'].is_a?(String)
      row["created_at"] = Time.parse(row['created_at']) \
        if row['created_at'].is_a?(String)
      
      row
    end
  end
  
  # Creates system offer for resource specified by _resource_kind_ in galaxy
  # specified by _galaxy_id_.
  #
  # System offer is an offer which does not belong to any planet and trades
  # resource for creds.
  # 
  # Its #to_rate is calculated by using #average and selling in most
  # expensive possible value.
  #
  def self.create_system_offer(galaxy_id, resource_kind)
    avg_rate = MarketRate.average(galaxy_id, resource_kind, KIND_CREDS)
    to_rate = avg_rate * (1 + Cfg.market_rate_offset)
    from_amount = Cfg.market_bot_random_resource(resource_kind)
    
    new(:from_amount => from_amount, :from_kind => resource_kind,
      :to_kind => KIND_CREDS, :to_rate => to_rate, :galaxy_id => galaxy_id)
  end
  
  # Save _object_ and dispatch event if is a planet.
  def self.save_obj_with_event(object)
    EventBroker.fire(object, EventBroker::CHANGED, 
      EventBroker::REASON_OWNER_PROP_CHANGE) \
      if object.is_a?(SsObject::Planet)
    object.save!
  end
end