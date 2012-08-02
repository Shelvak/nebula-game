# Helper object for handling +SsObject::Planet+ owner changes.
class SsObject::Planet::OwnerChangeHandler
  def initialize(planet, old_player, new_player)
    @planet = planet
    @old_player = old_player
    @new_player = new_player
  end

  def handle!
    # Transfers units, needs to be before #handle_population.
    handle_units!

    # Recalculates population for players.
    handle_population
    # Needs to be before #handle_scientists! and #handle_technologies! because
    # they count on proper #planets_count and #bg_planets_count.
    handle_planet_counts
    handle_points
    # Changes Player, but does not save him.
    handle_market_offers!
    # Save players for subsequent operations.
    save_players!

    handle_building_cooldowns!
    handle_radars!
    # Needs to be before #handle_scientists! because we need to pause
    # technologies which do not meet their planetary requirements anymore.
    handle_technologies!
    # Transfers scientists and updates scientist counts.
    handle_scientists!
    handle_explorations!
    # Depends on #handle_planet_counts.
    handle_objectives!
    # Add cooldown to planet on owner change.
    handle_cooldown!

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
    @old_player.recalculate_population if @old_player
    @new_player.recalculate_population if @new_player
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
      # Unhide units to prevent passing them around between players.
      unit.hidden = false
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
  def handle_points
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

  def handle_planet_counts
    solar_system = without_locking { @planet.solar_system }
    if solar_system.battleground?
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
        @old_player.pure_creds += market_offer.from_amount
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

  # Create cooldown in planet after its owner changes to prevent following
  # scenario:
  # Planet is owned by A. It has 10 Crows hidden inside. B flies into it.
  # Because non non-hidden combat units are there, A loses planet control and
  # crows become unhidden. However crows now coexist peacefully with B units and
  # B cannot claim planet, because there are enemy combat units inside.
  #
  # So we spawn a cooldown, that will check for combat after it expires and
  # everything is perfect.
  #
  def handle_cooldown!
    Cooldown.create_or_update!(@planet, Cfg.after_planet_owner_change_cooldown)
  end

  def save_players!
    @old_player.save! if @old_player && @old_player.changed?
    @new_player.save! if @new_player && @new_player.changed?
  end
end