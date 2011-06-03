module Trait::HasScientists
  def self.included(receiver)
    receiver.send :include, InstanceMethods
    receiver.extend ClassMethods
  end

  module InstanceMethods
    def scientists(level=nil)
      self.class.scientists(level || self.level)
    end

    def on_activation
      super
      player = planet.player
      player.change_scientist_count!(scientists) unless player.nil?
    end

    def on_deactivation
      super
      player = planet.player
      player.change_scientist_count!(-scientists) unless player.nil?
    end
  end

  module ClassMethods
    def scientists(level)
      evalproperty('scientists', nil, 'level' => level).round
    end
  end
end