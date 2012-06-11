# Informs in what scope some work should be done.
class Dispatcher::Scope
  WORLD    = :world
  CHAT     = :chat
  ENROLL   = :enroll
  LOGIN    = :login
  CONTROL  = :control
  LOW_PRIO = :low_prio

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

    # Control-related actions. Has to be responsive even if the main server
    # workers are busy.
    def control
      new(CONTROL)
    end

    # For tasks|create_player and attaching. Required because we have to
    # sequentially take home systems from the pool and position them.
    def enroll
      new(ENROLL)
    end

    # For players|login. Needs separate director because calls to website can
    # take quite long.
    def login
      new(LOGIN)
    end

    # For low priority tasks like cleaning up notifications or combat logs.
    def low_prio
      new(LOW_PRIO)
    end
  end
end