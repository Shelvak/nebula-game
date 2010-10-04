package models.building
{
   import models.tile.TileKind;
   
   import mx.collections.ArrayCollection;
   
   public class ZetiumExtractor extends Extractor
   {
      public static const RESTRICTED_TILES:ArrayCollection =
         new ArrayCollection(Extractor.RESTRICTED_TILES.source.concat(
            TileKind.GEOTHERMAL,
            TileKind.ORE
         ));
      override protected function getRestrictedTiles() : ArrayCollection
      {
         return RESTRICTED_TILES;
      }
   }
}