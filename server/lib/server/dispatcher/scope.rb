# Informs in what scope some work should be done.
class Dispatcher::Scope
  WORLD  = :world
  CHAT   = :chat
  ENROLL = :enroll
  LOGIN  = :login

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def to_s
    "<#{self.class} name=#{@name}>"
  end

  class << self
    # General director for world related actions.
    def world
      new(WORLD)
    end

    # Chat-related actions. Chat has to be responsive even if the main server
    # workers are busy.
    def chat
      new(CHAT)
    end

    # For tasks|create_player. Required because we have to sequentially take
    # home systems from the pool.
    def enroll
      new(ENROLL)
    end

    # For players|login. Needs separate director because calls to website can
    # take quite long.
    def login
      new(LOGIN)
    end
  end
end