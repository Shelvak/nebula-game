class Objective::Battle < Objective
  KEY = ''
  def self.resolve_key(klass); KEY; end

  # Outcomes are received from SpaceMule.
  #
  # {player_id (String) => outcome (Combat::OUTCOME_*, Fixnum)}
  #
  def self.progress(outcomes); super([outcomes]); end

  # Leave only outcomes that we want and prepare data for #count_benefits
  # here.
  def filter(outcomes_array)
    [Hash[outcomes_array[0].map do |string_player_id, outcome|
      player_id = string_player_id.to_i
      # We progress objective by 1 if it's a player (not NPC) and outcome is
      # right.
      player_id == 0 || outcome != self.outcome \
        ? nil : [player_id, 1]
    end.compact]]
  end

  # Just return data that #filter has prepared for us.
  def self.count_benefits(outcomes_array)
    outcomes_array[0]
  end
end