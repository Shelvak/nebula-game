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
       * Returns terrain name for a given type.
       * 
       * @param int type of a terrain
       * 
       * @return name of terrain
       */
      public static function getName(type:int) : String
      {
         switch (type) {
            case GRASS: return "earth";
            case DESERT: return "desert";
            case MUD: return "mud";
            case TWILIGHT: return "twilight";
            default:
               throw new Error("Unknown terrain type constant " + type + "!");
         }
      }
   }
}