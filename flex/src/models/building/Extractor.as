package models.building
{
   import models.tile.TileKind;
   
   import mx.collections.ArrayCollection;

   public class Extractor extends Building
   {
      /**
       * List of all extractor types
       */
      public static const ALL_EXTRACTORS:ArrayCollection = new ArrayCollection([
         BuildingType.METAL_EXTRACTOR,
         BuildingType.METAL_EXTRACTOR_T2,
         BuildingType.ZETIUM_EXTRACTOR,
         BuildingType.ZETIUM_EXTRACTOR_T2,
         BuildingType.GEOTHERMAL_PLANT
      ]);
      
      
      /**
       * Returns <code>true</code> if given type is one of extractor types or <code>false</code> otherwise.
       */
      public static function isExtractorType(type:String) : Boolean
      {
         return ALL_EXTRACTORS.contains(type);
      }
      
      
      public static const WIDTH:int = 2;
      public static const HEIGHT:int = 2;
      public static const RESTRICTED_TILES:ArrayCollection = new ArrayCollection(TileKind.NON_RESOURCE_TILES);
      override protected function getRestrictedTiles() : ArrayCollection
      {
         return RESTRICTED_TILES;
      }
   }
}