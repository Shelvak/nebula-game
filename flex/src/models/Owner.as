package models
{
   /**
    * Defines 4 available groups of property (unit, squadron and so on) owners.
    * 
    * @see OwnerColor
    */
   public final class Owner
   {
      public static const UNDEFINED:int = -1;
      public static const PLAYER:int = 0;
      public static const ALLY:int = 1;
      public static const NAP:int = 2;
      public static const ENEMY:int = 3;
   }
}