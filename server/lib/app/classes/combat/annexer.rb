class Combat::Annexer
  class << self
    # Annexes a +SsObject+ if:
    # 1. It was without an owner - keeps it that way.
    # 2. It was owned - remove ownership if planet was lost.
    # 
    # _planet_ is +SsObject::Planet+ in question.
    # _check_report_ is +Combat::CheckReport+
    # _outcomes_ is either nil or a {player_id => outcome} hash.
    #
    def annex!(planet, check_report, outcomes)
      if check_report.status == Combat::CheckReport::COMBAT
        # Don't do anything if no shots were shot.
        return if outcomes.nil?
        
        # There was a combat. Lets check if the owner of that planet lost (and
        # he is not NPC).
        if outcomes[planet.player_id] == Combat::OUTCOME_LOSE &&
            ! planet.player_id.nil?
          annex_planet(planet, outcomes)
        end
      elsif check_report.status == Combat::CheckReport::NO_CONFLICT && 
        planet.player_id.nil?
        # No conflict, it's a free annexable planet. Create notifications 
        # for all players who are in the planet.
        planet_free(planet, check_report.alliances)
      end
    end

    protected

    # Protects player from losing his last planet.
    def protect(planet, outcomes)
      duration = Cfg.planet_protection_duration(planet.solar_system.galaxy)

      outcomes.each do |player_id, outcome|
        Notification.create_for_planet_protected(player_id, planet,
          outcome, duration) unless player_id.nil?
      end

      Cooldown.create_or_update!(planet, duration.from_now)
    end
    
    # Remove planet ownership and notify all combat participants.
    def annex_planet(planet, outcomes)
      outcomes.each do |player_id, outcome|
        Notification.create_for_planet_annexed(player_id, planet,
          outcome) unless player_id.nil?
      end

      planet.player = nil
      planet.save!
    end
    
    # Planet is free, send notifications for everyone in alliances.
    def planet_free(planet, alliances)
      alliances.values.flatten.compact.each do |player|
        Notification.create_for_planet_annexed(player.id, planet, nil)
      end
    end
  end
end