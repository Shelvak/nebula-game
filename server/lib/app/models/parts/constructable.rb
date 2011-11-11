# Some shared methods for classes that can be constructed by constructor.
module Parts::Constructable
  # This is construction_mod passed from constructor. It is 0 by default.
  def constructor_construction_mod
    @constructor_construction_mod  || 0
  end

  def constructor_construction_mod=(value)
    @constructor_construction_mod  = value
  end
end