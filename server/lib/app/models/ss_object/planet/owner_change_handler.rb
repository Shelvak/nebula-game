# Helper object for handling +SsObject::Planet+ owner changes.
class SsObject::Planet::OwnerChangeHandler
  def initialize(planet, old_player, new_player)
    @planet = planet
    @old_player = old_player
    @new_player = new_player
  end

  def handle!
    handle_population
    handle_building_cooldowns!
    handle_radars!
    handle_scientists!
    handle_market_offers!
    handle_units!
    handle_explorations!
    handle_points!
    handle_objectives!
    handle_planet_counts!
    handle_technologies!

    save_players!

    EventBroker.fire(
      @planet, EventBroker::CHANGED, EventBroker::REASON_OWNER_CHANGED
    )
  end

private

  def units
    @units ||= Unit.
      in_location(@planet).
      where(:player_id => @old_player.try(:id))
  end

  def buildings
    @planet.buildings
  end

  def handle_population
    max_population_count = 0
    buildings.each do |building|
      if ! building.inactive? && building.respond_to?(:population)
        max_population_count += building.population
      end
    end

    @old_player.population_cap -= max_population_count if @old_player
    @new_player.population_cap += max_population_count if @new_player
  end

  def handle_building_cooldowns!
    buildings.each do |building|
      building.reset_cooldown! if building.respond_to?(:reset_cooldown!)
    end
  end

  def handle_radars!
    buildings.accept { |b| b.active? && b.is_a?(Trait::Radar) }.each do
      |building|

      zone = building.radar_zone
      Trait::Radar.decrease_vision(zone, @old_player) if @old_player
      Trait::Radar.increase_vision(zone, @new_player) if @new_player
    end
  end

  def handle_scientists!
    scientist_count = buildings.
      accept { |b| b.active? && b.respond_to?(:scientists) }.
      map(&:scientists).
      sum

    if scientist_count > 0
      @old_player.change_scientist_count!(- scientist_count) if @old_player
      @new_player.change_scientist_count!(scientist_count) if @new_player
    end
  end

  # Transfer any alive units that were not included in combat to new owner.
  def handle_units!
    changed = units.each_with_object([]) do |unit, array|
      unit.player = @new_player
      array << unit

      if unit.transporter?
        unit.units.each do |loaded|
          loaded.player = @new_player
          array << loaded
        end
      end
    end

    Unit.save_all_units(changed)
  end

  # Return exploring scientists if on a mission.
  def handle_explorations!
    @planet.stop_exploration!(@old_player) if @planet.exploring?
  end

  # Transfer all points to new player.
  def handle_points!
    points = buildings.reject(&:npc?).each_with_object({}) do |building, hash|
      points_attribute = building.points_attribute
      hash[points_attribute] ||= 0
      hash[points_attribute] += building.points_on_destroy
    end

    unless points.blank?
      points.each do |attribute, points|
        @old_player.send("#{attribute}=",
          @old_player.send(attribute) - points) if @old_player
        @new_player.send("#{attribute}=",
          @new_player.send(attribute) + points) if @new_player
      end
    end
  end

  def handle_objectives!
    Objective::HavePlanets.progress(@planet)

    # NPC buildings do not belong to player.
    player_buildings = buildings.reject(&:npc?)

    if @old_player
      Objective::HaveUpgradedTo.
        regress(player_buildings + units, player_id: @old_player.id)
    end

    if @new_player
      Objective::HaveUpgradedTo.
        progress(player_buildings + units, player_id: @new_player.id)
      Objective::AnnexPlanet.progress(@planet)
    end
  end

  def handle_planet_counts!
    solar_system = @planet.solar_system
    if solar_system.battleground?
      if @new_player
        Unit.give_units(
          CONFIG['battleground.planet.bonus'], @planet, @new_player
        )
      end
      @old_player.bg_planets_count -= 1 if @old_player
      @new_player.bg_planets_count += 1 if @new_player
    else
      @old_player.planets_count -= 1 if @old_player
      @new_player.planets_count += 1 if @new_player
    end
  end

  # Cancel all market offers where MarketOffer#from_kind was creds so
  # owner of the planet would retrieve his creds without fee.
  def handle_market_offers!
    return unless @old_player

    MarketOffer.
      where(:planet_id => @planet.id, :from_kind => MarketOffer::KIND_CREDS).
      each do |market_offer|
        @old_player.creds += market_offer.from_amount
        market_offer.destroy!
      end
  end

  def handle_technologies!
    return unless @old_player
    paused_technologies = @old_player.technologies.upgrading.all.compact_map do
      |technology|

      # We need to pass old player, because it hasn't been saved to database
      # yet.
      if technology.planets_requirement_met?(@old_player)
        nil
      else
        technology.pause!
        [technology, Reducer::RELEASED]
      end
    end

    Notification.create_for_technologies_changed(
      @old_player.id, paused_technologies
    ) unless paused_technologies.blank?
  end

  def save_players!
    # Do this finally, because they depend on actual in-DB units and
    # construction queue entries.
    @old_player.recalculate_population if @old_player
    @new_player.recalculate_population if @new_player

    @old_player.save! if @old_player && @old_player.changed?
    @new_player.save! if @new_player && @new_player.changed?
  end
end