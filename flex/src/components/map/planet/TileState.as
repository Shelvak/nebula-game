package components.map.planet
{
   /**
    * Defines all awailable states of a tile.
    */
   internal final class TileState
   {
      /**
       * A building can be built on a tile.
       */
      public static const BUILD_OK:int = 0;
      
      /**
       * A building can't be built on a tile due to some obstacle on it.
       */
      public static const BUILD_RESTRICT:int = 1;
      
      
      private static const COLORS:Object = new Object();
      COLORS[BUILD_OK]       = 0x00FF00;
      COLORS[BUILD_RESTRICT] = 0xFF0000;
      
      
      /**
       * Returns color of a tile in a given state.
       */
      public static function getColor(state:int) : uint
      {
         return COLORS[state];
      }
   }
}