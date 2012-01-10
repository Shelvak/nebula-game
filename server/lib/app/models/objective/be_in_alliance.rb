class Objective::BeInAlliance < Objective
  # Hardcoded objective key.
  KEY = "BeInAlliance"

  def initial_completed(player_id)
    Player.find(player_id).alliance_id.nil? ? 0 : 1
  end

  # Return hardcoded objective key.
  def self.resolve_key(klass); KEY; end

  # Progress for this player.
  def self.progress(player); super([player]); end

  def self.count_benefits(players)
    players.grouped_counts { |player| player.id }
  end
end