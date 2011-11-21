package models.factories
{
   import flash.geom.Point;
   
   import models.folliage.BlockingFolliage;
   import models.folliage.NonblockingFolliage;
   import models.tile.FolliageTileKind;
   import models.tile.TerrainType;
   import models.tile.Tile;
   
   import utils.Objects;
   
   
   /**
    * Lets easily create various folliages.
    */
   public class FolliageFactory
   {
      /**
       * Creates nonblocking folliage from a raw object.
       *  
       * @param data Object representing a folliage.
       * 
       * @return instance of <code>NonblockingFolliage</code>.
       */
      public static function nonblockingFromObject(data:Object) : NonblockingFolliage {
         return Objects.create(NonblockingFolliage, data);
      }
      
      /**
       * Creates blocking folliage from a tile and optionally sets terrain type.
       *  
       * @param tile A tile that represents a folliage.
       * @param terrainType Type of the terrain.
       * 
       * @return instance of <code>BlockingFolliage</code>.
       */
      public static function blocking(tile:Tile, terrainType:int = TerrainType.GRASS) : BlockingFolliage {
         if (!tile.isFolliage())
            throw new Error("Unable to create BlockingFolliage " +
                            "instance form non-folliage tile kind!");
         
         var folliage:BlockingFolliage = new BlockingFolliage();
         folliage.id = tile.id;
         folliage.kind = tile.kind;
         folliage.x = tile.x;
         folliage.y = tile.y;
         folliage.terrainType = terrainType;
         var size:Point = FolliageTileKind.getSize(folliage.kind);
         folliage.setSize(size.x, size.y);
         
         return folliage;
      }
   }
}