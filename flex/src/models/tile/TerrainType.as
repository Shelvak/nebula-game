package models.tile
{
   /**
    * Defines available different types of terrain (base regular type).
    */
   public class TerrainType
   {
      public static const GRASS:int = 0;
      public static const DESERT:int = 1;
      public static const MUD:int = 2;
      
      
      /**
       * A hash that maps landable planet variations to their terrain type. 
       */
      private static const terrainMap:Object =
         {
            0:TerrainType.GRASS,
            1:TerrainType.GRASS,
            2:TerrainType.GRASS,
            3:TerrainType.GRASS,
            4:TerrainType.DESERT,
            5:TerrainType.DESERT,
            6:TerrainType.DESERT,
            7:TerrainType.MUD,
            8:TerrainType.MUD
         };
      
      /**
       * A hash that maps terrain type integers to terrain type names.
       */
      private static const terrainNameMap:Object =
         {
            (String(TerrainType.GRASS)): "grass",
            (String(TerrainType.DESERT)): "desert",
            (String(TerrainType.MUD)): "mud"
         }
      
      
      /**
       * Returns terrain type for a given planet variation.
       * 
       * @param variation Variation of a planet.
       * 
       * @return <code>TerrainType.GRASS</code>, <code>TerrainType.DESERT</code> or
       * <code>TerrainType.MUD</code>
       */
      public static function getType(variation:int) : int
      {
         return terrainMap[variation];
      }
      
      
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