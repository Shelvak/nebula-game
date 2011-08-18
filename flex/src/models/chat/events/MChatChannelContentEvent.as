package models.chat.events
{
   import flash.events.Event;
   
   public class MChatChannelContentEvent extends Event
   {
      /**
       * Dispatched when a message has been added to an instance of <code>MChatChannelContent</code>.
       * @eventType messageAdd
       */
      public static const MESSAGE_ADD:String = "messageAdd";
      
      /**
       * Dispatched when a message has been removed from an instance of <code>MChatChannelContent</code>.
       * @eventType messageRemove
       */
      public static const MESSAGE_REMOVE:String = "messageRemove";
      
      
      public function MChatChannelContentEvent(type:String) {
         super(type, false, false);
      }
   }
}