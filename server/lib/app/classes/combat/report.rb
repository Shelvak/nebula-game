# Combat report returned from
class Combat::Report
  # +ClientLocation+.
  attr_reader :location

  # Combat::AlliancesList#as_json
  attr_reader :alliances

  # Same +Hash+ that was passed to Combat#new. Documented in Nap#get_rules.
  attr_reader :nap_rules

  # Combat log as returned Combat#run_ticks.
  attr_reader :log

  # +Hash+ of Combat statistical data.
  #
  # {
  #   :damage_dealt_player => {player_id => damage},
  #   :damage_dealt_alliance => {alliance_id => damage},
  #   :damage_taken_player => {player_id => damage},
  #   :damage_taken_alliance => {alliance_id => damage},
  #   :xp_earned => {player_id => xp},
  #   :points_earned => {player_id => points}
  # }
  attr_reader :statistics

  # {player_id => outcome} +Hash+ where outcome is one
  # of the OUTCOME_LOSE, OUTCOME_TIE or OUTCOME_WIN constants.
  attr_reader :outcomes

  # {model => player_id} +Hash+.
  attr_reader :killed_by

  # Resources left after battle.
  attr_reader :metal, :energy, :zetium

  # This player has won the battle. Note that if even if you and Nap ended
  # up in a tie because of the pact, both of you will still get WIN outcome.
  OUTCOME_WIN = 0
  # This player has lost the battle (all your and your alliance units &
  # buildings were destroyed).
  OUTCOME_LOSE = 1
  # This player ended up in a tie at this battle (battle ended before you or
  # your allies were wiped out from the battlefield).
  OUTCOME_TIE = 2

  # Configuration keys embedded into replay info so it could be replayed
  # later.
  REPLAY_INFO_CONFIG_REGEXP = /^(
    units\..+(kind|hp|guns)$
    |
    ui\.
  )/x

  def initialize(location, alliances, nap_rules, log, statistics, outcomes,
  killed_by)
    @location = location
    @alliances = alliances
    @nap_rules = nap_rules
    @log = log
    @statistics = statistics
    @outcomes = outcomes
    @killed_by = killed_by

    calculate_wreckages
  end

  # All the data needed to play back combat replay.
  def replay_info
    {
      :location => @location.as_json,
      :alliances => @alliances,
      :nap_rules => @nap_rules,
      :outcomes => @outcomes,
      :log => @log,
      :config => CONFIG.filter(REPLAY_INFO_CONFIG_REGEXP)
    }
  end

  protected
  # Calculates how much wreckage is left from killed units.
  def calculate_wreckages
    if @killed_by.blank?
      @metal, @energy, @zetium = 0
    else
      @metal, @energy, @zetium = Wreckage.calculate(@killed_by.keys)
    end
  end
end
