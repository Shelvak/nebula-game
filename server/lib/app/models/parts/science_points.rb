module Parts::SciencePoints
  def self.included(receiver)
    receiver.extend ClassMethods
  end

  module ClassMethods
    def points_attribute; :science_points; end
  end
end
