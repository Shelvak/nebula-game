class Planet::Jumpgate < Planet
  include Unlandable

  def self.planet_class
    :jumpgate
  end
end