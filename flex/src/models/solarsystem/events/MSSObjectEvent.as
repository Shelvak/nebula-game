package models.solarsystem.events
{
   import flash.events.Event;


   public class MSSObjectEvent extends Event
   {
      public static const RAID_STATE_CHANGE:String = "raidStateChange";
      public static const PLAYER_CHANGE: String = "playerChange";
      public static const OWNER_CHANGE: String = "ownerChange";
      public static const COOLDOWN_CHANGE: String = "cooldownChange";
      public static const TERRAIN_CHANGE: String = "terrainChange";
      public static const NEXT_SPAWN_CHANGE: String = "nextSpawnChange";
      public static const SPAWN_COUNTER_CHANGE: String = "spawnCounterChange";

      public function MSSObjectEvent(type: String,
                                     bubbles: Boolean = false,
                                     cancelable: Boolean = false) {
         super(type, bubbles, cancelable);
      }
   }
}