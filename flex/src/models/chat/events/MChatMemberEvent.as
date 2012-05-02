package models.chat.events
{
   import flash.events.Event;


   public class MChatMemberEvent extends Event
   {
      /**
       * Dispatched when <code>MChatMember.isOnline</code> property changes.
       */
      public static const IS_ONLINE_CHANGE: String = "isOnlineChange";

      /**
       * Dispatched when <code>MChatMember.isIgnored</code> property changes.
       */
      public static const IS_IGNORED_CHANGE: String = "isIgnoredChange";

      /**
       * Dispatched when <code>MChatMember.name</code> property changes.
       */
      public static const NAME_CHANGE: String = "nameChange";


      public function MChatMemberEvent(type: String) {
         super(type);
      }
   }
}