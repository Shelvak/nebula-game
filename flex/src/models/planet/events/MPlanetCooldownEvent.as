package models.planet.events
{
   import flash.events.Event;


   public class MPlanetCooldownEvent extends Event
   {
      public static const CAN_REINITIATE_COMBAT_CHANGE: String = "CAN_REINITIATE_COMBAT_CHANGE";

      public function MPlanetCooldownEvent(type: String) {
         super(type);
      }
   }
}
