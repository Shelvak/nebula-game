# Informs in what scope some work should be done.
class Dispatcher::Scope
  CHAT   = :chat
  WORLD  = :world
  SLOW   = :slow

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def to_s
    "<#{self.class} name=#{@name}>"
  end

  class << self
    def chat
      new(CHAT)
    end

    def world
      new(WORLD)
    end

    def slow
      new(SLOW)
    end
  end
end