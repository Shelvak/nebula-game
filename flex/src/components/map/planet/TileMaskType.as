package components.map.planet
{
   /**
    * Defines available tile mask types. 
    */   
   public class TileMaskType
   {
      /**
       * Whole tile mask. 
       */      
      public static const TILE: String = "tile";
      
      /**
       * Mask for blending outer sides of tiles. Original mask should be applied on the logical
       * top of a tile. 
       */
      public static const SIDE: String = "side";
      
      /**
       * Mask for blending left and right corners of tiles. Original mask should be applied on the
       * left side of a tile.
       */
      public static const CORNER_WIDTH: String = "corner_width";
      
      /**
       * Mask for blending top and bottom corners of tiles. Original mask should be applied on top
       * of a tile.
       */
      public static const CORNER_HEIGHT: String = "corner_height";
   }
}