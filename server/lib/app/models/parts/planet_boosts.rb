module Parts::PlanetBoosts
  def boosted?(resource, attr)
    value = send("#{resource}_#{attr}_boost_ends_at")
    ! value.nil? && value >= Time.now
  end

  def metal_rate_boosted?; boosted?(:metal, :rate); end
  def metal_storage_boosted?; boosted?(:metal, :storage); end
  def energy_rate_boosted?; boosted?(:energy, :rate); end
  def energy_storage_boosted?; boosted?(:energy, :storage); end
  def zetium_rate_boosted?; boosted?(:zetium, :rate); end
  def zetium_storage_boosted?; boosted?(:zetium, :storage); end

  # These aliases are used in SsObject::Planet#resource_modifiers

  def metal_boosted?; metal_rate_boosted?; end
  def energy_boosted?; energy_rate_boosted?; end
  def zetium_boosted?; zetium_rate_boosted?; end
  
  # Boosts planets _resource_ _attribute_.
  #
  # _resource_ can be one of the +Resource::TYPES+ symbol.
  # _attribute_ can be either :rate or :storage.
  def boost!(resource, attribute)
    resource = resource.to_sym
    attribute = attribute.to_sym
    
    raise GameLogicError.new("Unknown resource #{resource}!") \
      unless Resources::TYPES.include?(resource)
    raise GameLogicError.new("Unknown attribute #{attribute}!") \
      unless [:rate, :storage].include?(attribute)

    player = self.player
    raise ArgumentError.new("Planet player cannot be nil!") if player.nil?
    creds_needed = Cfg.planet_boost_cost
    raise GameLogicError.new("Not enough creds! Required #{creds_needed
      }, has: #{player.creds}.") if player.creds < creds_needed
    stats = CredStats.boost(player, resource, attribute)
    player.creds -= creds_needed
    
    attr = :"#{resource}_#{attribute}_boost_ends_at"
    duration = Cfg.planet_boost_duration
    current = self.send(attr)
    now = Time.now
    from = current.nil? || current < now ? now : current
    self.send(:"#{attr}=", from + duration)

    self.save!
    player.save!
    EventBroker.fire(self, EventBroker::CHANGED,
      EventBroker::REASON_OWNER_PROP_CHANGE)
    stats.save!

    self
  end
end
