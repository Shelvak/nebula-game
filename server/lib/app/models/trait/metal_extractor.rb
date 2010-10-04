module Trait::MetalExtractor
  include Trait::RequiringTile

	module ClassMethods

	end

	module InstanceMethods
    def validate_position_check_ore
      require_tile(Tile::ORE, "Ore")
    end
	end

	def self.included(receiver)
    Trait.child_included(self, receiver)
	end
end