package models.solarsystem.events
{
   import flash.events.Event;


   public class MSolarSystemEvent extends Event
   {
      /**
       * @see models.solarSystem.MSolarSystem
       */
      public static const SHIELD_OWNER_CHANGE: String = "shieldOwnerChange";

      /**
       * @see models.solarSystem.MSolarSystem
       */
      public static const SHIELD_ENDS_AT_CHANGE: String = "shieldEndsAtChange";

      /**
       * @see models.solarSystem.MSolarSystem
       */
      public static const SHIELD_ENDS_IN_CHANGE: String = "shieldEndsInChange";

      public function MSolarSystemEvent(type: String) {
         super(type);
      }
   }
}