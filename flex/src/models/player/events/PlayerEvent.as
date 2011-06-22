package models.player.events
{
   import flash.events.Event;
   
   public class PlayerEvent extends Event
   {
      public static const SCIENTISTS_CHANGE: String = "scientistsChange";
      public static const CREDS_CHANGE: String = "credsChange";
      
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
      
      
      public function PlayerEvent(type:String)
      {
         super(type);
      }
   }
}