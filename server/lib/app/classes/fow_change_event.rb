# Encapsulates information about FOW change. You should inform alliance
# members about the change. Also inform player if it is set (this is needed
# when player is thrown out of alliance, both his and alliance visibility
# changes then).
class FowChangeEvent
  attr_reader :player, :alliance

  def initialize(player, alliance)
    @player = player
    @alliance = alliance
  end

  def player?
    ! @player.nil?
  end

  def alliance?
    ! @alliance.nil?
  end

  # Array of +Player+ ids which should be notified.
  def player_ids
    ids = alliance? ? alliance.member_ids : []
    ids.push player.id unless ids.include?(player.id)

    ids
  end

  def ==(other)
    if other.is_a?(self.class)
      alliance == other.alliance && player == other.player
    else
      false
    end
  end
end
