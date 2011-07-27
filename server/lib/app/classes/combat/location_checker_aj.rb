# Location checker that is used after jump. Instead of initiating combat it
# adds a small cooldown to that location and does not try to annex planets.
class Combat::LocationCheckerAj < Combat::LocationChecker
  class << self
    protected
    # Create cooldown for a short time before actual battle will begin.
    def on_conflict(location_point, check_report)
      Cooldown.create_unless_exists(location_point, 
        CONFIG['combat.cooldown.after_jump.duration'].from_now)
      
      # No combat means no assets.
      nil
    end
    
    # Don't try to annex planet after jump unless there were no conflicts.
    def annex_planet(location_point, check_report, assets)
      super(location_point, check_report, assets) \
        if check_report.status == Combat::CheckReport::NO_CONFLICT
    end
  end
end