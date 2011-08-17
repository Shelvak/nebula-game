package models.chat.events
{
   import flash.events.Event;
   
   
   public class MChatChannelEvent extends Event
   {
      /**
       * Dispatched when <code>MChatChannel.hasUnreadMessages</code> property changes.
       * @eventType hasUnreadMessagesChange
       */
      public static const HAS_UNREAD_MESSAGES_CHANGE:String = "hasUnreadMessagesChange";
      
      /**
       * Dispatched when <code>MChatChannelPrivate.isFriendOnline</code> property changes.
       * @eventType isFriendOnlineChange
       */
      public static const IS_FRIEND_ONLINE_CHANGE:String = "isFriendOnlineChange";
      
      /**
       * Dispatched when <code>MChatChannel.numMembers</code> property changes.
       * @eventType numMembersChange
       */
      public static const NUM_MEMBERS_CHANGE:String = "numMembersChange";
      
      
      public function MChatChannelEvent(type:String) {
         super(type, false, false);
      }
   }
}