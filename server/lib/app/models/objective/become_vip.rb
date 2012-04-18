class Objective::BecomeVip < Objective
  # Hardcoded objective key.
  KEY = "Vip"
  
  def initial_completed(player_id)
    without_locking do
      Player.find(player_id).vip_level >= level ? 1 : 0
    end
  end

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
