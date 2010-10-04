# Provides #require_tile method
module Trait::RequiringTile
	module ClassMethods

	end

	module InstanceMethods
    # Require that building x, y is on required _tile_ type.
    # 
    # Add error otherwise.
    def require_tile(tile, tile_name=nil)
      tile_name ||= tile

      unless Tile.count(:conditions => [
        "planet_id=? AND x=? AND y=? AND kind=?",
        planet_id, x, y, tile
      ]) > 0
        errors.add(:base,"#{to_s} must be built on #{tile_name} tile!")
      end
    end
	end

	def self.included(receiver)
    Trait.child_included(self, receiver)
	end
end