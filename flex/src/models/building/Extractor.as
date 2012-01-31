package models.building
{
   import models.tile.TileKind;

   import mx.collections.ArrayCollection;


   public class Extractor extends Building
   {
      /**
       * List of all extractor types
       */
      public static const ALL_EXTRACTORS: ArrayCollection
                             = new ArrayCollection([
         BuildingType.METAL_EXTRACTOR,
         BuildingType.METAL_EXTRACTOR_T2,
         BuildingType.NPC_METAL_EXTRACTOR,
         BuildingType.ZETIUM_EXTRACTOR,
         BuildingType.ZETIUM_EXTRACTOR_T2,
         BuildingType.NPC_ZETIUM_EXTRACTOR,
         BuildingType.GEOTHERMAL_PLANT,
         BuildingType.NPC_GEOTHERMAL_PLANT
      ]);

      public function get baseResource(): int {
         throw new Error("This method is abstract");
      }

      /**
       * Returns <code>true</code> if given type is one of extractor types or <code>false</code> otherwise.
       */
      public static function isExtractorType(type: String): Boolean {
         return ALL_EXTRACTORS.contains(type);
      }

      public static const WIDTH: int = 2;
      public static const HEIGHT: int = 2;
      public static const RESTRICTED_TILES: ArrayCollection
                             = new ArrayCollection(TileKind.NON_RESOURCE_TILES);

      override protected function getRestrictedTiles(): ArrayCollection {
         return RESTRICTED_TILES;
      }

      override public function isTileRestricted(t:int,
                                                borderTile: Boolean = false): Boolean {
         return !borderTile && getRestrictedTiles().contains(t);
      }
   }
}