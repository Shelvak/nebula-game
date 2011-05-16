class Objective::AccelerateFlight < Objective
  KEY = ""
  def self.resolve_key(klass); KEY; end

  # Progress for this player.
  def self.progress(player); super([player]); end

  def self.count_benefits(players); players.grouped_counts(&:id); end
end