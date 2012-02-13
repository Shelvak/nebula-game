# Informs in what scope some work should be done.
class Dispatcher::Scope
  CHAT   = :chat
  GALAXY = :galaxy
  PLAYER = :player

  attr_reader :ids

  def initialize(scope, ids)
    @scope = scope
    @ids = ids
  end

  def chat?; @scope == CHAT; end
  def galaxy?; @scope == GALAXY; end
  def player?; @scope == PLAYER; end

  # This work only involves chat.
  def self.chat
    new(CHAT, nil)
  end

  # This work involves whole galaxy, however its players should not be blocked.
  def self.galaxy(galaxy_ir_id)
    typesig binding, [Galaxy, Fixnum]
    new(GALAXY, [galaxy_ir_id.is_a?(Fixnum) ? galaxy_ir_id : galaxy_ir_id.id])
  end

  # This work involves several players.
  def self.player(player_or_id)
    typesig binding, [Player, Fixnum]
    players([player_or_id.is_a?(Fixnum) ? player_or_id : player_or_id.id])
  end

  # This work involves several players.
  def self.players(player_ids)
    typesig binding, Array
    new(PLAYER, player_ids)
  end
end