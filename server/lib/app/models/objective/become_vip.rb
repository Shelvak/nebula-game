class Objective::BecomeVip < Objective
  # Hardcoded objective key.
  KEY = "Vip"

  def filter(players)
    players.accept { |player| player.vip_level >= level }
  end

  # Return hardcoded objective key.
  def self.resolve_key(klass); KEY; end

  # Progress for this player.
  def self.progress(player); super([player]); end

  def self.count_benefits(players)
    players.grouped_counts { |player| player.id }
  end
end