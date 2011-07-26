# Returned by Combat#check_for_enemies.
class Combat::CheckReport
  # +Symbol+ determining if combat should be initiated or not.
  attr_reader :status

  # +Hash+ of alliances. See Player#grouped_by_alliance.
  attr_reader :alliances

  # +Hash+ of nap rules. See Nap#get_rules.
  attr_reader :nap_rules

  # Nothing interesting is going on in this place.
  NO_CONFLICT = :no_conflict
  # Let there be combat in this place!
  COMBAT = :combat

  def initialize(status, alliances, nap_rules={})
    @status = status
    @alliances = alliances
    @nap_rules = nap_rules
  end
end
