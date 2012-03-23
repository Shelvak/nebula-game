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
      
      /**
       * Dispatched when <code>MChatChannel.generateJoinLeaveMsgs</code> property changes.
       * @eventType generateJoinLeaveMsgsChange
       */
      public static const GENERATE_JOIN_LEAVE_MSGS_CHANGE:String = "generateJoinLeaveMsgsChange";

      /**
       * Dispatched when <code>MChatMembersList.nameFilter</code> property changes.
       * @event type membersFilterChange
       */
      public static const MEMBERS_FILTER_CHANGE:String = "membersFilterChange";

      /**
       * Dispatched to fix url bug in chat, should be temporary, TODO ?
       * @eventType gotSomeMessage
       */
      public static const GOT_SOME_MESSAGE:String = "gotSomeMessage";
      
      
      public function MChatChannelEvent(type:String) {
         super(type, false, false);
      }
   }
}