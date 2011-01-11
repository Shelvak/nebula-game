package models
{
   /**
    * Defines 4 available groups of property (unit, squadron and so on) owners.
    */
   public final class Owner
   {
      public static const UNDEFINED:int = -1;
      public static const PLAYER:int = 0;
      public static const ALLY:int = 1;
      public static const NAP:int = 2;
      public static const ENEMY:int = 3;
      
      
      /**
       * Returns a color used to marke various objects as belonging to a player of given owner type.
       */
      public static function getColor(owner:int) : uint
      {
         switch (owner)
         {
            case PLAYER: return 0x00FF00;
            case ALLY:   return 0x0000FF;
            case NAP:    return 0xFFFFFF;
            case ENEMY:  return 0xFF0000;
         }
         return 0;
      }
   }
}