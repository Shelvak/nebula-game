class MarketOffer < ActiveRecord::Base
  belongs_to :planet, :class_name => "SsObject::Planet"
  delegate :player, :player_id, :to => :planet
  
  KIND_METAL = 0
  KIND_ENERGY = 1
  KIND_ZETIUM = 2
  KIND_CREDS = 3
  
  validate do
    errors.add(:from_kind, "cannot be creds") if from_kind == KIND_CREDS
  end
  
  before_save do
    avg_rate = self.class.avg_rate(from_kind, to_kind)
    offset = CONFIG['market.avg_rate.offset']
    if to_rate < (low = avg_rate * (1 - offset)) then self.to_rate = low
    elsif to_rate > (high = avg_rate * (1 + offset)) then self.to_rate = high
    end
    
    true
  end
  
  # Buys _amount_ of _source_kind_ from this +Offer+ to _buyer_planet_.
  def buy!(buyer_planet, amount)
    raise GameLogicError.new("Cannot buy 0 or less! Wanted: #{amount}") \
      if amount <= 0
    amount = from_amount if amount > from_amount
        
    cost = (amount * to_rate).ceil
    buyer_source, bs_attr = self.class.resolve_kind(buyer_planet, to_kind)
    buyer_target, bt_attr = self.class.resolve_kind(buyer_planet, from_kind)
    seller_target, _ = self.class.resolve_kind(planet, to_kind)
    
    buyer_has = buyer_source.send(bs_attr)
    raise GameLogicError.new("Not enough funds for #{buyer_source
      }! Wanted #{cost} #{bs_attr} but it only had #{buyer_has}."
    ) if buyer_has < cost
    
    # Subtract resource that buyer is paying with from him.
    buyer_source.send(:"#{bs_attr}=", buyer_has - cost)
    # Add resource that buyer has bought from seller.
    buyer_target.send(:"#{bt_attr}=", 
      buyer_target.send(bt_attr) + amount)
    # Add resource that buyer is paying with to seller.
    seller_target.send(:"#{bs_attr}=", 
      seller_target.send(bs_attr) + cost)
    # Reduce bought amount from offer.
    self.from_amount -= amount
    
    transaction do
      [buyer_source, buyer_target, seller_target].uniq.each do |obj|
        save_obj_with_event(obj)
      end
      from_amount == 0 ? destroy : save!
    end
    
    self
  end
  
  # Cancels offer. Returns #from_amount which is left to parent planet.
  def cancel!
    planet, attr = self.class.resolve_kind(self.planet, from_kind)
    planet.send(:"#{attr}=", planet.send(attr) + from_amount)
    save_obj_with_event(planet)
    destroy
  end
  
  # Resolves _kind_ into _source_ (+SsObject::Planet+ or +Player+ and 
  # _attr_ (_metal_, _energy_, _zetium_ or _creds_).
  def self.resolve_kind(source, kind)
    case kind
    when KIND_METAL then attr = :metal
    when KIND_ENERGY then attr = :energy
    when KIND_ZETIUM then attr = :zetium
    when KIND_CREDS then source = source.player; attr = :pure_creds
    end
    
    [source, attr]
  end
  
  # Return average market rate for given resource pair. Raises 
  # ArgumentError if rates pair is invalid.
  #
  # Returns Float.
  def self.avg_rate(from_kind, to_kind)
    seed_amount, seed_rate = CONFIG[
      "market.avg_rate.seed.#{from_kind}.#{to_kind}"
    ]
    raise ArgumentError.new("Unknown kind pair! from_kind: #{
      from_kind.inspect}, to_kind: #{to_kind.inspect}") if seed_amount.nil?
    
    connection.select_value("
      SELECT SUM(rate * amount) / SUM(amount) as avg_rate FROM (
        SELECT #{seed_amount} as amount, #{seed_rate} as rate
        UNION
        #{where(:from_kind => from_kind, :to_kind => to_kind).
          select("from_amount as amount, to_rate as rate").to_sql}
      ) as subselect
    ")
  end
  
  private
  # Save _object_ and dispatch event if is a planet.
  def save_obj_with_event(object)
    EventBroker.fire(object, EventBroker::CHANGED, 
      EventBroker::REASON_OWNER_PROP_CHANGE) \
      if object.is_a?(SsObject::Planet)
    object.save!
  end
end