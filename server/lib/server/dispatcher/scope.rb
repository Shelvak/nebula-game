# Informs in what scope some work should be done.
class Dispatcher::Scope
  CHAT   = :chat
  WORLD  = :world

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def to_s
    "<#{self.class} name=#{@name}>"
  end

  class << self
    # This work only involves chat.
    def chat
      new(CHAT)
    end

    # This work only game world.
    def world
      new(WORLD)
    end
  end
end