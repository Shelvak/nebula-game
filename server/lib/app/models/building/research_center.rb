class Building::ResearchCenter < Building
  include Trait::HasScientists
  include Parts::SciencePoints
end