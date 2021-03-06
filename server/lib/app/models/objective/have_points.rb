# Objective type that is progressed when player has some number of points.
#
# _count_ for this should always be 1.
#
class Objective::HavePoints < Objective
  def self.points_method; :points; end

  def initial_completed(player_id)
    Player.find(player_id).send(self.class.points_method) >= limit ? 1 : 0
  end

  # Filter players that do not have enough points yet.
  def filter(players)
    players.reject do |player|
      player.send(self.class.points_method) < limit
    end
  end

  # Wrap _player_ into Array and pass it to #super.
  def self.progress(player, *args)
    super([player], *args)
  end

  # Each matching player will benefit from this one time.
  def self.count_benefits(players, options)
    players.map { |player| [player.id, 1] }
  end
end