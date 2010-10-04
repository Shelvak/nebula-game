module Trait::ZetiumExtractor
  include Trait::RequiringTile

	module ClassMethods

	end

	module InstanceMethods
    def validate_position_check_zetium
      require_tile(Tile::ZETIUM, "Zetium")
    end
	end

	def self.included(receiver)
    Trait.child_included(self, receiver)
	end
end