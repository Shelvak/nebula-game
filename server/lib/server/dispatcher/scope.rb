# Informs in what scope some work should be done.
class Dispatcher::Scope
  CHAT   = :chat
  LOGIN  = :login
  GALAXY = :galaxy
  PLAYER = :player

  attr_reader :args

  def initialize(scope, args)
    @scope = scope
    @args = args
  end

  def chat?; @scope == CHAT; end
  def login?; @scope == LOGIN; end
  def galaxy?; @scope == GALAXY; end
  def player?; @scope == PLAYER; end

  # This work only involves chat.
  def self.chat
    new(CHAT, nil)
  end

  # This work only involves login.
  def self.login
    new(LOGIN, nil)
  end

  # This work involves whole galaxy, however its players should not be blocked.
  def self.galaxy(galaxy_id)
    new(GALAXY, [galaxy_id])
  end

  # This work involves several players.
  def self.player(player_ids)
    new(PLAYER, player_ids)
  end
end