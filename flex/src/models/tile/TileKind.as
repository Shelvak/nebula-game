package models.tile
{
   /**
    * Defines constants of available tile types in the game.
    */
   public final class TileKind
   {
      /**
       * Defines constant of regular tile type. 
       */      
      public static const REGULAR:int = 255;
      
      /**
       * Defines constant of geothermal tile kind. This is a resource.
       */
      public static const GEOTHERMAL: int = 1;
      
      /**
       * Defines constant of junkyard tile kind.
       */
      public static const JUNKYARD: int = 4;
      
      /**
       * Defines constant of noxrium tile kind.
       */
      public static const NOXRIUM: int = 3;
      
      /**
       * Defines constant of ore tile kind.  This is a resource.
       */
      public static const ORE: int = 0;
      
      /**
       * Defines constant of sand tile kind.
       * This is the default kind of a tile.
       */
      public static const SAND: int = 5;
      
      /**
       * Defines constant of titan tile kind.
       */
      public static const TITAN: int = 6;
      
      /**
       * Defines constant for zetium tile kind.  This is a resource.
       */
      public static const ZETIUM: int = 2;
      
      /**
       * Defines constant for water tile kind.
       */
      public static const WATER:int = 7;
      
      
      /**
       * @return true if the given tile kind is a resource tile kind, false - otherwise.
       */
      public static function isResourceKind (kind: int) :Boolean
      {
         return kind == GEOTHERMAL || kind == ORE || kind == ZETIUM;
      }
      
      /** 
       * Array of tiles that are not of resource type.
       */      
      public static const NON_RESOURCE_TILES:Array = [
         JUNKYARD,
         NOXRIUM,
         SAND,
         TITAN,
         WATER,
         REGULAR
      ];
      
      /**
       * Array of resource tile types. 
       */      
      public static const RESOURCE_TILES:Array = [
         GEOTHERMAL,
         ORE,
         ZETIUM
      ];
   }
}