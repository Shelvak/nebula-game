package models.chat.events
{
   import flash.events.Event;
   
   
   public class MChatMemberEvent extends Event
   {
      /**
       * Dispatched when <code>MChatMember.isOnline</code> property changes.
       * 
       * @eventType isOnlineChange
       */
      public static const IS_ONLINE_CHANGE:String = "isOnlineChange";
      
      
      public function MChatMemberEvent(type:String)
      {
         super(type);
      }
   }
}