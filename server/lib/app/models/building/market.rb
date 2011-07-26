class Building::Market < Building
  # Market fee for adding new offers to market. Returns Float, e.g.: 0.15.
  def fee; self.class.fee(level); end
  
  # Returns full cost with market fee for offer creation.
  def full_cost(amount)
    (amount * (1 + fee)).ceil
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
    source.send(:"#{attr}=", current - full_cost)
    
    offer = MarketOffer.new(:planet => planet, 
      :from_amount => from_amount, :from_kind => from_kind,
      :to_kind => to_kind, :to_rate => to_rate)
    
    transaction do
      offer.save!
      MarketOffer.save_obj_with_event(source)
    end
    
    offer
  end
  
  class << self
    def fee(level); evalproperty('fee', nil, 'level' => level); end
  end
end