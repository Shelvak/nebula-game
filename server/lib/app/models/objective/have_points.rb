# Objective type that is progressed when player has some number of points.
#
# _count_ for this should always be 1.
#
class Objective::HavePoints < Objective
  # Filter players that do not have enough points yet.
  def filter(players)
    players.reject { |player| player.points < limit }
  end

  # Wrap _player_ into Array and pass it to #super.
  def self.progress(player)
    super([player])
  end

  # Each matching player will benefit from this one time.
  def self.count_benefits(players)
    players.map { |player| [player.id, 1] }
  end
end