package models
{
   /**
    * Defines colors used to mark various objects as belonging to some owner group defined by
    * <code>Owner<code>.
    * 
    * @see Owner
    */
   public final class OwnerColor
   {
      public static const UNDEFINED:int = 0xFF0000;
      public static const ENEMY:int     = UNDEFINED;
      public static const PLAYER:int    = 0x00FF00;
      public static const ALLY:int      = 0x00C0FF;
      public static const NAP:int       = 0xFFFFFF;
      
      
      /**
       * Returns a color used to mark various objects as belonging to a player of given owner type.
       */
      public static function getColor(owner:int) : uint
      {
         switch (owner)
         {
            case Owner.PLAYER:    return PLAYER;
            case Owner.ALLY:      return ALLY;
            case Owner.NAP:       return NAP;
            case Owner.ENEMY:     return ENEMY;
            case Owner.UNDEFINED: return UNDEFINED;
         }
         return 0;
      }
   }
}