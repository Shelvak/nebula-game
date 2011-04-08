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
      
      
      public function MChatEvent(type:String)
      {
         super(type, false, false);
      }
   }
}