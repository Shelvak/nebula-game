package components.planetmapeditor
{
   import interfaces.IEqualsComparable;

   import models.tile.TerrainType;


   [Bindable]
   public class IRTileKindM implements IEqualsComparable
   {
      public var tileKind: int;
      public var terrainType: int;
      
      public function IRTileKindM(tileKind:int,
                                  terrainType:int = TerrainType.GRASS) {
         this.tileKind = tileKind;
         this.terrainType = terrainType;
      }

      public function equals(o: Object): Boolean {
         const another:IRTileKindM = o as IRTileKindM;
         return another != null
                   && another.tileKind == this.tileKind
                   && another.terrainType == this.terrainType;
      }
   }
}
