class UnitLocation < LocationPoint
  def initialize(id)
    super(id, Location::UNIT, nil, nil)
  end
end