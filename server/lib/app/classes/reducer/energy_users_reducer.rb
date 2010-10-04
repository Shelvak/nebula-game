class Reducer::EnergyUsersReducer < Reducer
  def self.get_resource(target)
    target.energy_usage_rate
  end

  def self.get_min_resource(target)
    get_resource(target)
  end

  def self.release_resource(target)
    target.deactivate!
  end
end
