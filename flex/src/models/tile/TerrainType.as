package models.tile
{
   /**
    * Defines available different types of terrain (base regular type).
    */
   public final class TerrainType
   {
      private static const NAME_GRASS: String = "earth";
      private static const NAME_DESERT: String = "desert";
      private static const NAME_MUD: String = "mud";
      private static const NAME_TWILIGHT: String = "twilight";

      public static const GRASS: int = 0;
      public static const DESERT: int = 1;
      public static const MUD: int = 2;
      public static const TWILIGHT: int = 3;

      /**
       * Returns terrain name for a given type.
       *
       * @param int type of a terrain
       *
       * @return name of terrain
       */
      public static function getName(type: int,
                                     returnUpperCase: Boolean = false): String {
         var name: String;
         switch (type) {
            case GRASS:
               name = NAME_GRASS;
               break;
            case DESERT:
               name = NAME_DESERT;
               break;
            case MUD:
               name = NAME_MUD;
               break;
            case TWILIGHT:
               name = NAME_TWILIGHT;
               break;
            default:
               throw new Error("Unknown terrain type constant " + type + "!");
         }
         return returnUpperCase ? name.toUpperCase() : name;
      }

      public static function getType(name: String): int {
         switch (name.toLowerCase()) {
            case NAME_GRASS: return GRASS;
            case NAME_DESERT: return DESERT;
            case NAME_MUD: return MUD;
            case NAME_TWILIGHT: return TWILIGHT;
            default:
               throw new Error("Unknown terrain name: " + name);
         }
      }
   }
}