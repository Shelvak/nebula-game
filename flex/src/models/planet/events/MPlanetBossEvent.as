package models.planet.events
{
   import flash.events.Event;


   public class MPlanetBossEvent extends Event
   {
      public static const UNITS_CHANGE: String = "unitsChange";
      public static const CAN_SPAWN_CHANGE: String = "canSpawnChange";
      public static const CAN_SPAWN_NOW_CHANGE: String = "canSpawnNowChange";
      public static const MESSAGE_SPAWN_ABILITY_CHANGE: String = "messageSpawnAbilityChange";

      public function MPlanetBossEvent(type: String) {
         super(type);
      }
   }
}
