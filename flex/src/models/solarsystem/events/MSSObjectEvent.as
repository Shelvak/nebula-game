package models.solarsystem.events
{
   import flash.events.Event;


   public class MSSObjectEvent extends Event
   {
      /**
       * @see models.solarsystem.MSSObject
       */
      public static const PLAYER_CHANGE: String = "playerChange";

      /**
       * @see models.solarsystem.MSSObject
       */
      public static const OWNER_CHANGE: String = "ownerChange";

      /**
       * @see models.solarsystem.MSSObject
       */
      public static const COOLDOWN_CHANGE: String = "cooldownChange";

      public function MSSObjectEvent(type: String,
                                    bubbles: Boolean = false,
                                    cancelable: Boolean = false) {
         super(type, bubbles, cancelable);
      }
   }
}