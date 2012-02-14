class MarketController < GenericController
  # Return average market rate for selling resource 1 -> resource 2.
  # 
  # Invocation: by client
  # 
  # Parameters:
  # - from_kind (Fixnum): resource kind you are offering
  # - to_kind (Fixnum): resource kind you are demanding
  # 
  # Response:
  # - avg_rate (Float): average market rate for that resource pair
  #
  ACTION_AVG_RATE = 'market|avg_rate'

  AVG_RATE_OPTIONS = logged_in + required(:from_kind => Fixnum, :to_kind => Fixnum)
  def self.avg_rate_scope(m) end # TODO
  def self.avg_rate_action(m)
    avg_rate = MarketRate.average(m.player.galaxy_id, m.params['from_kind'],
      m.params['to_kind'])
    
    respond m, :avg_rate => avg_rate
  end
  
  # Send list of all market offers in the galaxy.
  # 
  # Invocation: by client
  # 
  # Parameters:
  # - planet_id (Fixnum): ID of the planet market is in.
  # 
  # Response:
  # - public_offers (Hash[]): offers that you can buy. 
  # See MarketOffer#as_json for +Hash+ format.
  # - planet_offers (Hash[]): offers being offered by you in this planet.
  # - offer_count (Fixnum): total number of your offers.
  #
  ACTION_INDEX = 'market|index'

  INDEX_OPTIONS = logged_in + required(:planet_id => Fixnum)
  def self.index_scope(m) end # TODO
  def self.index_action(m)
    # Ensure that planet_id is valid.
    planet = m.player.planets.find(m.params['planet_id'])
    planet_ids = m.player.planets.select("id").c_select_values
    
    respond m,
      :public_offers => MarketOffer.fast_offers(
        "#{MarketOffer.table_name}.galaxy_id=?", m.player.galaxy_id),
      :planet_offers => MarketOffer.fast_offers("planet_id=?", planet.id),
      :offer_count => MarketOffer.where(:planet_id => planet_ids).count
  end
  
  # Create a new offer.
  #
  # Invocation: by client
  # 
  # Parameters:
  # - market_id (Fixnum): ID of the market
  # - from_amount (Fixnum): amount of resource you want to offer
  # - from_kind (Fixnum): kind of resource you are offering. One of the
  # MarketOffer::KIND_* constants.
  # - to_kind (Fixnum): kind of resource you are demanding.
  # - to_rate (Fixnum || Float): exchange rate. 
  # How much resources of _to_kind_ you are demanding for 1 unit of 
  # _from_kind_ resource.
  # 
  # Response:
  # - offer (Hash): MarketOffer#as_json
  #
  ACTION_NEW = 'market|new'

  NEW_OPTIONS = logged_in + required(:market_id => Fixnum, 
    :from_amount => Fixnum, :from_kind => Fixnum, :to_kind => Fixnum,
    :to_rate => [Fixnum, Float])
  def self.new_scope(m) end # TODO
  def self.new_action(m)
    market = Building::Market.find(m.params['market_id'])
    raise GameLogicError.new("This planet does not belong to you!") \
      unless market.planet.player_id == m.player.id
    
    offer = market.create_offer!(m.params['from_kind'],
        m.params['from_amount'], m.params['to_kind'], m.params['to_rate'])
    respond m, :offer => offer.as_json
  end
  
  # Cancel given market offer. Return resources left on offer to planet.
  # 
  # Invocation: by client
  # 
  # Parameters:
  # - offer_id (Fixnum): ID of the offer being canceled
  # 
  # Response: None
  #
  ACTION_CANCEL = 'market|cancel'

  CANCEL_OPTIONS = logged_in + required(:offer_id => Fixnum)
  def self.cancel_scope(m) end # TODO
  def self.cancel_action(m)
    offer = MarketOffer.find(m.params['offer_id'])
    raise GameLogicError.new(
      "Cannot cancel offer that you do not own!"
    ) unless offer.planet.player_id == m.player.id

    offer.cancel!
  end
  
  # Buy some part of the offer from the market. Resources then are 
  # transmitted to you planet/player.
  # 
  # Invocation: by client
  # 
  # Parameters:
  # - offer_id (Fixnum): ID of the offer being bought
  # - planet_id (Fixnum): ID of the planet where offer is being bought
  # - amount (Fixnum): amount of the resource being bought
  # 
  # Response:
  # - amount (Fixnum): amount actually bought. If 0, offer was destroyed
  # and purchase was unsuccessful. If > 0 - purchase was successful.
  #
  ACTION_BUY = 'market|buy'

  BUY_OPTIONS = logged_in + required(:offer_id => Fixnum, :planet_id => Fixnum,
      :amount => Fixnum)
  def self.buy_scope(m) end # TODO
  def self.buy_action(m)
    offer = begin
      MarketOffer.find(m.params['offer_id'])
    rescue ActiveRecord::RecordNotFound
      respond m, :amount => 0
      return
    end
      
    raise GameLogicError.new("Cannot buy offer from other galaxy!") \
      unless offer.galaxy_id == m.player.galaxy_id
    raise GameLogicError.new("Cannot buy offer from self!") \
      if ! offer.system? && offer.planet.player_id == m.player.id
    
    buyer_planet = m.player.planets.find(m.params['planet_id'])
    
    amount_bought = offer.buy!(buyer_planet, m.params['amount'])
    respond m, :amount => amount_bought
  end
end