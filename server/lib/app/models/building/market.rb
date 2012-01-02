class Building::Market < Building
  # Market fee for adding new offers to market. Returns Float, e.g.: 0.15.
  def fee; self.class.fee(level); end
  
  # Returns full cost with market fee for offer creation.
  def full_cost(amount)
    # Don't ceil the fee here or calculation in client gets overly 
    # complicated in edge cases, e.g. when there is 0,5 of a resource 
    # missing.
    amount + (amount * fee).floor
  end
  
  # Creates an market offer where _from_amount_ of _from_kind_ resources 
  # are being traded to _to_kind_ resource at rate of _to_rate_.
  # 
  # Market fee is also calculated and deducted from planets resources. It
  # depends on market level.
  #
  def create_offer!(from_kind, from_amount, to_kind, to_rate)
    full_cost = self.full_cost(from_amount)
    source, attr = MarketOffer.resolve_kind(planet, from_kind)
    
    current = source.send(attr)
    raise GameLogicError.new(
      "Cannot create offer. #{full_cost} #{attr} is needed on #{source
      } but only #{current} is available!") if current < full_cost
    if from_kind == MarketOffer::KIND_CREDS
      fee = (from_amount * self.fee)
      stats = CredStats.market_fee(player, fee)
    end
    
    source.send(:"#{attr}=", current - full_cost)
    
    offer = MarketOffer.new(:planet => planet, 
      :from_amount => from_amount, :from_kind => from_kind,
      :to_kind => to_kind, :to_rate => to_rate)
    
    stats.save! if stats
    offer.save!
    MarketOffer.save_obj_with_event(source)

    offer
  end
  
  class << self
    def fee(level); evalproperty('fee', nil, 'level' => level); end
  end
end