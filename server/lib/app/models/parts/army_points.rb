module Parts::ArmyPoints
  def self.included(receiver)
    receiver.extend ClassMethods
  end

  module ClassMethods
    def points_attribute; :army_points; end
  end
end
