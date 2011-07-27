# Offer in a galaxy market that allows players to trade with each other.
#
# Offers belong to planets, so if planet owner changes, that means that
# offer owner also changes.
# 
# Some of the attributes:
# - to_rate (Float): how much of _to_kind_ resource you want for 1 of 
# _from_kind_ resource.
#
class MarketOffer < ActiveRecord::Base
  belongs_to :galaxy
  belongs_to :planet, :class_name => "SsObject::Planet"
  delegate :player, :player_id, :to => :planet
  
  KIND_METAL = 0
  KIND_ENERGY = 1
  KIND_ZETIUM = 2
  KIND_CREDS = 3
  
  validate do
    min_amount = CONFIG['market.offer.min_amount']
    errors.add(:from_amount, 
      "cannot be less than minimal #{min_amount}, however #{from_amount
      } was offered.") if new_record? && from_amount < min_amount
    errors.add(:from_kind, "cannot be creds") if from_kind == KIND_CREDS
    errors.add(:base, "Maximum number of market offers reached!") \
      if player.market_offers.size >= CONFIG['market.offers.max']
  end
  
  before_create do
    self.galaxy_id ||= player.galaxy_id
    avg_rate = self.class.avg_rate(galaxy_id, from_kind, to_kind)
    offset = CONFIG['market.avg_rate.offset']
    
    low = avg_rate * (1 - offset)
    high = avg_rate * (1 + offset)
    if to_rate < low 
      self.to_rate = low
    elsif to_rate > high
      self.to_rate = high
    end
    
    true
  end
  
  # Returns JSON hash for this +MarketOffer+.
  #
  # {
  #   'id' => Fixnum,
  #   'player' => Player#minimal,
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
      'player' => Player.minimal(player_id),
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
    seller_target, _ = self.class.resolve_kind(planet, to_kind)
    
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
    # Add resource that buyer is paying with to seller.
    seller_target.send(:"#{bs_attr}=", 
      seller_target.send(bs_attr) + cost)
    # Reduce bought amount from offer.
    self.from_amount -= amount
    
    transaction do
      [buyer_source, buyer_target, seller_target].uniq.each do |obj|
        self.class.save_obj_with_event(obj)
      end
      from_amount == 0 ? destroy : save!
      percentage_bought = amount.to_f / original_amount
      Notification.create_for_market_offer_bought(
        self, buyer_planet.player, amount, cost
      ) if percentage_bought >= CONFIG['market.buy.notification.threshold']
    end
    
    amount
  end
  
  # Cancels offer. Returns #from_amount which is left to parent planet.
  def cancel!
    planet, attr = self.class.resolve_kind(self.planet, from_kind)
    planet.send(:"#{attr}=", planet.send(attr) + from_amount)
    self.class.save_obj_with_event(planet)
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
  
  # Returns Array of #as_json type Hashes by given _conditions_. Does it 
  # swiftly!
  def self.fast_offers(*conditions)
    t = "`#{table_name}`"
    p = "`#{Player.table_name}`"
    
    (conditions.blank? ? self : where(*conditions)).
      joins(:planet => :player).
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
      row["created_at"] = Time.parse(row['created_at']) \
        if row['created_at'].is_a?(String)
      
      row
    end
  end
  
  # Return average market rate for given resource pair. Raises 
  # ArgumentError if rates pair is invalid.
  #
  # Returns Float.
  def self.avg_rate(galaxy_id, from_kind, to_kind)
    seed_amount, seed_rate = CONFIG[
      "market.avg_rate.seed.#{from_kind}.#{to_kind}"
    ]
    raise ArgumentError.new("Unknown kind pair! from_kind: #{
      from_kind.inspect}, to_kind: #{to_kind.inspect}") if seed_amount.nil?
    
    connection.select_value("
      SELECT SUM(rate * amount) / SUM(amount) as avg_rate FROM (
        SELECT #{seed_amount} as amount, #{seed_rate} as rate
        UNION
        #{where(:from_kind => from_kind, :to_kind => to_kind, 
                :galaxy_id => galaxy_id).
          select("from_amount as amount, to_rate as rate").to_sql}
      ) as subselect
    ").to_f # JRuby compatibility.
  end
  
  # Save _object_ and dispatch event if is a planet.
  def self.save_obj_with_event(object)
    EventBroker.fire(object, EventBroker::CHANGED, 
      EventBroker::REASON_OWNER_PROP_CHANGE) \
      if object.is_a?(SsObject::Planet)
    object.save!
  end
end