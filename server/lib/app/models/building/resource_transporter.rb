class Building::ResourceTransporter < Building
  include Parts::WithCooldown

  # Raised if target planet does not have a transporter.
  class NoTransporterError < GameError; end

  def max_volume(level=nil)
    self.class.max_volume(level || self.level)
  end

  def self.max_volume(level)
    evalproperty("max_volume", nil, {'level' => level}).round
  end

  def cooldown_time(volume, level=nil)
    self.class.cooldown_time(volume, level || self.level)
  end

  def self.cooldown_time(volume, level)
    mod = cooldown_mod(level)
    (volume * mod).ceil
  end

  def self.cooldown_mod(level)
    evalproperty("mod.cooldown", nil, {'level' => level})
  end

  def fee(level=nil)
    self.class.fee(level || self.level)
  end

  def self.fee(level)
    evalproperty("fee", nil, {'level' => level})
  end

  def transport!(target_planet, metal, energy, zetium)
    raise GameLogicError.new(
      "Building must be active and without cooldown to transport resources!"
    ) unless active? && cooldown_expired?

    volume = Resources.total_volume(metal, energy, zetium)
    max_volume = self.max_volume
    raise GameLogicError.new(
      "Cannot transport #{metal} m, #{energy} e, #{zetium} z, total volume (#{
      volume}) is greater than max (#{max_volume})"
    ) if volume > max_volume

    planet = self.planet
    raise GameLogicError.new(
      "Not enough resources to transport! M: req:#{metal}/has:#{
        planet.metal}, E: req:#{energy}/has:#{planet.energy}, Z: req:#{
        zetium}/has:#{planet.zetium}"
    ) unless planet.metal >= metal && planet.energy >= energy &&
      planet.zetium >= zetium

    raise GameLogicError.new(
      "Can only transfer to planet which belongs to same player! Source: #{
      planet}, target: #{target_planet}"
    ) if planet.player_id != target_planet.player_id

    raise NoTransporterError.new(
      "#{target_planet} does not have an active resource transporter!"
    ) unless self.class.where(
      :planet_id => target_planet.id, :state => STATE_ACTIVE
    ).exists?

    self.cooldown_ends_at = cooldown_time(volume).seconds.from_now
    arrival_mult = 1.0 - fee

    save!
    planet.increase!(:metal => -metal, :energy => -energy, :zetium => -zetium)
    target_planet.increase!(
      :metal => metal * arrival_mult, :energy => energy * arrival_mult,
      :zetium => zetium * arrival_mult
    )

    EventBroker.fire(self, EventBroker::CHANGED)
  end
end