module Trait::GeothermalPlant
  include Trait::RequiringTile
  
	module ClassMethods

	end

	module InstanceMethods
    def validate_position_check_geothermal
      require_tile(Tile::GEOTHERMAL, "Geothermal")
    end
	end

	def self.included(receiver)
    Trait.child_included(self, receiver)
	end
end