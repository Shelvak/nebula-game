package models.tile
{
   import models.BaseModel;
   
   
   
   /**
    * A tile of a planet. 
    */   
   [Bindable]
   public class Tile extends BaseModel
   {
      /**
       * Width of the planet tile in map.
       */
      public static const IMAGE_WIDTH:  Number = 98;
      
      /**
       * Height of the planet tile in map.
       */
      public static const IMAGE_HEIGHT: Number = 50;
      
      [Required]
      /**
       * Kind of the tile.
       * 
       * @default TileKind.SAND
       */
      public var kind: int = TileKind.SAND;
      
      [Optional]
      /**
       * Variation of a tile. This property makes sense only if a tile
       * is of folliage kind. For all other tiles this is equal to -1
       * and should be ignored.
       * 
       * @default -1
       */
      public var variation:int = -1;
      
      [Required]
      /**
       * Horizontal coordinate (in tiles) of a tile in a map.
       */
      public var x: Number = 0;
      
      [Required]
      /**
       * Vertical coordinate (in tiles) of a tile in a map.
       */
      public var y: Number = 0;
      
      /**
       * Determines if a tile is of resource kind (ORE, GEOTHERMAL, ZETIUM).
       * 
       * @return true if this tile is of resource kind, false otherwise.
       */
      public function isResource() : Boolean
      {
         return TileKind.isResourceKind(kind);
      }
      
      /**
       * Determines if a tile is of folliage kind (<code>FolliageTileKind</code>).
       * 
       * @return true if this tile is of folliage kind, false otherwise.
       */
      public function isFolliage() : Boolean
      {
         return FolliageTileKind.isFolliageKind(kind);
      }
      
      /**
       * Makes exact copy of this instance of <code>Tile</code> and marks it as fake.
       */ 
      public function cloneFake () :Tile
      {
         var t: Tile = new Tile ();
         t.kind = kind;
         t.x = x;
         t.y = y;
         t.id = id;
         t.pending = pending;
         t.fake = true;
         return t;
      }
   }
}