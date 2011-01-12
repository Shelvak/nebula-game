package models.tile
{
   /**
    * Defines available different types of terrain (base regular type).
    */
   public final class TerrainType
   {
      public static const GRASS:int = 0;
      public static const DESERT:int = 1;
      public static const MUD:int = 2;
      public static const TWILIGHT:int = 3;
      
      
      /**
       * A hash that maps terrain type integers to terrain type names.
       */
      private static const terrainNameMap:Object =
         {
            (String(GRASS)): "earth",
            (String(DESERT)): "desert",
            (String(MUD)): "mud",
            (String(TWILIGHT)): "twilight"
         };
      
      
      /**
       * Returns terrain name for a given type.
       * 
       * @param int type of a terrain
       * 
       * @return name of terrain
       */
      public static function getName(type:int) : String
      {
         return terrainNameMap[type];
      }
   }
}