package models.chat.events
{
   import flash.events.Event;
   
   
   public class MChatChannelEvent extends Event
   {
      /**
       * Dispatched when <code>MChatChannel.hasUnreadMessages</code> property changes.
       */
      public static const HAS_UNREAD_MESSAGES_CHANGE:String = "hasUnreadMessagesChange";
      
      /**
       * Dispatched when <code>MChatChannelPrivate.isFriendOnline</code> property changes.
       */
      public static const IS_FRIEND_ONLINE_CHANGE:String = "isFriendOnlineChange";
      
      /**
       * Dispatched when <code>MChatChannel.numMembers</code> property changes.
       */
      public static const NUM_MEMBERS_CHANGE:String = "numMembersChange";
      
      /**
       * Dispatched when <code>MChatChannel.generateJoinLeaveMsgs</code> property changes.
       */
      public static const GENERATE_JOIN_LEAVE_MSGS_CHANGE:String = "generateJoinLeaveMsgsChange";

      /**
       * Dispatched when <code>MChatMembersList.nameFilter</code> property changes.
       */
      public static const MEMBERS_FILTER_CHANGE:String = "membersFilterChange";

      /**
       * Dispatched to fix url bug in chat, should be temporary, TODO ?
       */
      public static const GOT_SOME_MESSAGE:String = "gotSomeMessage";

      /**
       * Dispatched when <code>MChatMembersList.userInput</code> property changes.
       */
      public static const USER_INPUT_CHANGE: String = "userInputChange";
      
      
      public function MChatChannelEvent(type:String) {
         super(type, false, false);
      }
   }
}