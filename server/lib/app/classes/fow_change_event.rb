# Encapsulates information about FOW change. You should inform alliance
# members about the change. Also inform player if it is set (this is needed
# when player is thrown out of alliance, both his and alliance visibility
# changes then).
class FowChangeEvent
  def initialize(player, alliance)
    @player_ids = alliance ? alliance.member_ids : []
    @player_ids.push player.id unless @player_ids.include?(player.id)
  end

  # Array of +Player+ ids which should be notified.
  attr_reader :player_ids

  # Equality for being able to test it.
  def ==(other)
    other.is_a?(self.class) && @player_ids == other.player_ids
  end
end
