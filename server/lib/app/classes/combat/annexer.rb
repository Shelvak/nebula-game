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
        # There was a combat. Lets check if the owner of that planet lost.
        if outcomes[planet.player_id] == Combat::CheckReport::OUTCOME_LOSE
          if planet.player && planet.player.planet_count == 1
            # Don't take players last planet.
            protect(planet, outcomes)
          else
            # Take the planet away from him.
            annex_planet(planet, outcomes)
          end
        end
      elsif check_report.status == Combat::CheckReport::NO_CONFLICT && 
        planet.player_id.nil?
        # No conflict, it's a free annexable planet. Create notifications 
        # for all players who are in the planet.
        planet_free(planet, check_report)
      end
    end

    protected

    # Protects player from losing his last planet.
    def protect(planet, outcomes)
      ActiveRecord::Base.transaction do
        outcomes.each do |player_id, outcome|
          Notification.create_for_planet_protected(player_id, planet, 
            outcome) unless player_id.nil?
        end
        
        Cooldown.create_or_update!(planet,
          Cfg.planet_protection_duration.from_now)
      end
    end
    
    # Remove planet ownership and notify all combat participants.
    def annex_planet(planet, outcomes)
      ActiveRecord::Base.transaction do
        outcomes.each do |player_id, outcome|
          Notification.create_for_planet_annexed(player_id, planet, 
            outcome) unless player_id.nil?
        end
        
        planet.player = nil
        planet.save!
      end
    end
    
    # Planet is free, send notifications for everyone in alliances.
    def planet_free(planet, alliances)
      ActiveRecord::Base.transaction do
        alliances.each do |_, players|
          players.each do |player|
            Notification.create_for_planet_annexed(player.id, planet, nil) \
              unless player.nil?
          end
        end
      end
    end
  end
end