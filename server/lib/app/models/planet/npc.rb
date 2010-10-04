class Planet::Npc < Planet
  include Unlandable

  def self.planet_class
    :npc
  end
end