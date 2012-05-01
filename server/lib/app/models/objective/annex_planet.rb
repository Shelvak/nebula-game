class Objective::AnnexPlanet < Objective
  def self.progress(planet, *args)
    typesig_bindless [['planet', planet]], SsObject::Planet
    super([planet], *args)
  end
end