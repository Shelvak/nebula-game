package models.building
{
   import models.tile.TileKind;
   
   import mx.collections.ArrayCollection;

   public class CollectorT3 extends Extractor
   {
      
      private static const BASE_RESOURCE: int = TileKind.GEOTHERMAL;
      
      public static const RESTRICTED_TILES:ArrayCollection =
         new ArrayCollection(Extractor.RESTRICTED_TILES.source.concat(
            TileKind.ORE,
            TileKind.ZETIUM
         ));
      override protected function getRestrictedTiles() : ArrayCollection
      {
         return RESTRICTED_TILES;
      }
      public override function get baseResource(): int
      {
         return BASE_RESOURCE;
      }
   }
}