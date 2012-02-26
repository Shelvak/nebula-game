package components.movement.speedup.events
{
   import flash.events.Event;


   public class SpeedControlEvent extends Event
   {
      public static const SPEED_MODIFIER_CHANGE: String = "speedModifierChange";
      public static const PLAYER_CREDS_CHANGE: String = "playerCredsChange";
      public static const ARRIVAL_TIME_CHANGE: String = "arrivalTimeChange";

      public function SpeedControlEvent(type: String) {
         super(type);
      }
   }
}
