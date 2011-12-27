package models
{
   /**
    * Defines 4 available groups of property (unit, squadron and so on) owners.
    * 
    * @see OwnerColor
    */
   public final class Owner
   {
      public static const UNDEFINED:int = -10;
      public static const NPC:int = -1;
      public static const PLAYER:int = 0;
      public static const ALLY:int = 1;
      public static const NAP:int = 2;
      public static const ENEMY:int = 3;
      
      /**
       * All types of owners except for <code>UNDEFINED</code> in the following
       * order: <code>NPC, PLAYER, ALLY, NAP, ENEMY</code>.
       * 
       * <p><b>Do not modify at runtime!</b></p>
       */
      public static const VALID_OWNER_TYPES:Array = [NPC, PLAYER, ALLY, NAP, ENEMY];

      /**
       * All available types of owners including <code>UNDEFINED</code>.
       * <code>UNDEFINED</code> is the last element in the array.
       *
       * <p><b>Do not modify at runtime!</b></p>
       */
      public static const ALL_OWNER_TYPES:Array = VALID_OWNER_TYPES.concat(UNDEFINED);
   }
}