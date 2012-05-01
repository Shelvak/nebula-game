class Objective::AccelerateFlight < Objective
  KEY = ""
  def self.resolve_key(klass); KEY; end

  # Progress for this player.
  def self.progress(player, *args); super([player], *args); end

  def self.count_benefits(players, options); players.grouped_counts(&:id); end
end