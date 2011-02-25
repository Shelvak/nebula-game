module Parts::EconomyPoints
  def self.included(receiver)
    receiver.extend ClassMethods
  end

  module ClassMethods
    def points_attribute; :economy_points; end
  end
end
