package models.chat.events
{
   import flash.events.Event;
   
   
   public class MChatEvent extends Event
   {
      /**
       * Dispatched when <code>MChat.selectedChannel</code> property has been changed either
       * programaticly or by user interaction.
       * 
       * @eventType selectedChannelChange
       */
      public static const SELECTED_CHANNEL_CHANGE:String = "selectedChannelChange";
      
      
      /**
       * Dispatched when <code>MChat.privateChannelOpen</code> property has changed.
       * 
       * @eventType privateChannelOpenChange
       */
      public static const PRIVATE_CHANNEL_OPEN_CHANGE:String = "hprivateChannelOpenChange";
      
      
      /**
       * Dispatched when <code>MChat.allianceChannelOpen</code> property has changed.
       * 
       * @eventType allianceChannelOpenChange
       */
      public static const ALLIANCE_CHANNEL_OPEN_CHANGE:String = "allianceChannelOpenChange";
      
      
      public function MChatEvent(type:String)
      {
         super(type, false, false);
      }
   }
}