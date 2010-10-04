package models.building
{
   import models.tile.TileKind;
   
   import mx.collections.ArrayCollection;

   public class Extractor extends Building
   {
      public static const RESTRICTED_TILES:ArrayCollection =
         new ArrayCollection(TileKind.NON_RESOURCE_TILES);
      override protected function getRestrictedTiles() : ArrayCollection
      {
         return RESTRICTED_TILES;
      }
   }
}