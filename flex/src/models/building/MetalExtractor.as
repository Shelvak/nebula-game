package models.building
{
   import models.tile.TileKind;
   
   import mx.collections.ArrayCollection;
   
   public class MetalExtractor extends Extractor
   {
      
      private static const BASE_RESOURCE: int = TileKind.ORE;
      
      public static const RESTRICTED_TILES:ArrayCollection =
         new ArrayCollection(Extractor.RESTRICTED_TILES.source.concat(
            TileKind.GEOTHERMAL,
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