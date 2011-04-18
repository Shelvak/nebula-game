package models.chat.events
{
   import flash.events.Event;
   
   
   public class MChatChannelEvent extends Event
   {
      /**
       * Dispatched when <code>MChatChannel.hasUnreadMessages</code> property changes.
       * 
       * @eventType hasUnreadMessagesChange
       */
      public static const HAS_UNREAD_MESSAGES_CHANGE:String = "hasUnreadMessagesChange";
      
      
      public function MChatChannelEvent(type:String)
      {
         super(type, bubbles, cancelable);
      }
   }
}