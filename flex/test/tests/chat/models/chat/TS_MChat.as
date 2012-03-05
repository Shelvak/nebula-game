package tests.chat.models.chat
{
   [Suite]
   [RunWith("org.flexunit.runners.Suite")]
   public class TS_MChat
   {
      public var tc_MChat_initialization: TC_MChat_initialization;
      public var tc_MChat_members: TC_MChat_members;
      public var tc_MChat_memberOnlineStatus: TC_MChat_memberOnlineStatus;
      public var tc_MChat_messages: TC_MChat_messagesSendConfirmation;
      public var tc_MChat_publicMessages: TC_MChat_publicMessages;
      public var tc_MChat_privateMessages: TC_MChat_privateMessages;
      public var tc_MChat_ui: TC_MChat_ui;
      public var tc_MChat_hasUnreadAllianceMsg: TC_MChat_hasUnreadAllianceMsg;
      public var tc_MChat_hasUnreadPrivateMsg: TC_MChat_hasUnreadPrivateMsg;
      public var tc_MChat_hasUnreadMainMsg: TC_MChat_hasUnreadMainMsg;
      public var tc_MChat_openPrivateChannel: TC_MChat_openPrivateChannel;
      public var tc_MChat_closeChannel: TC_MChat_closeChannel;
      public var tc_MChat_ignoredMembers: TC_MChat_ignoredMembers;
      public var tc_MChat: TC_MChat;
   }
}