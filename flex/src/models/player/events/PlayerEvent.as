package models.player.events
{
   import flash.events.Event;
   
   public class PlayerEvent extends Event
   {
      public static const SCIENTISTS_CHANGE: String = "scientistsChange";
      public static const CREDS_CHANGE: String = "credsChange";
      public static const POPULATION_CAP_CHANGE: String = "populationCapChange";
      public static const POPULATION_CHANGE: String = "populationChange";
      
      /**
       * Dispatched when <code>Player.allianceId</code> property changes.
       * 
       * @eventType allianceIdChange
       */
      public static const ALLIANCE_ID_CHANGE:String = "allianceIdChange";
      
      /**
       * Dispatched when <code>Player.allianceOwner</code> property changes.
       * 
       * @eventType allianceOwnerChange
       */
      public static const ALLIANCE_OWNER_CHANGE:String = "allianceOwnerChange";
      
      /**
       * Dispatched when <code>Player.alliancePlayerCount</code> property changes.
       * 
       * @eventType alliancePlayerCountChange
       */
      public static const ALLIANCE_PLAYER_COUNT_CHANGE:String = "alliancePlayerCountChange";
      
      /**
       * Dispatched when <code>Player.maxAlliancePlayerCount</code> property changes.
       * 
       * @eventType maxAlliancePlayerCountChange
       */
      public static const MAX_ALLIANCE_PLAYER_COUNT_CHANGE:String = "maxAlliancePlayerCountChange";
      
      /**
       * Dispached when <code>Player.allianceCooldown</code> starts or ends.
       * 
       * @eventType allianceCooldownChange
       */
      public static const ALLIANCE_COOLDOWN_CHANGE:String = "allianceCooldownChange";
      
      
      public function PlayerEvent(type:String)
      {
         super(type);
      }
   }
}