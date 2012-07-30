class Objective::Battle < Objective
  KEY = ''
  def self.resolve_key(klass); KEY; end

  # Outcomes are received from SpaceMule.
  #
  # {player_id (String) => outcome (Combat::OUTCOME_*, Fixnum)}
  #
  def self.progress(outcomes, *args); super([outcomes], *args); end

  # Leave only outcomes that we want and prepare data for #count_benefits
  # here.
  def filter(outcomes_array)
    filtered = outcomes_array[0].each_with_object({}) do
      |(string_player_id, outcome), hash|

      player_id = string_player_id.to_i
      # We progress objective by 1 if it's a player (not NPC) and outcome is
      # right.
      hash[player_id] = 1 unless player_id == 0 || outcome != self.outcome
    end
    [filtered]
  end

  # Just return data that #filter has prepared for us.
  def self.count_benefits(outcomes_array, options)
    outcomes_array[0]
  end
end