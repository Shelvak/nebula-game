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
end
