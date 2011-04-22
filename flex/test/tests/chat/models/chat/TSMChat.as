package tests.chat.models.chat
{
   [Suite]
   [RunWith("org.flexunit.runners.Suite")]
   public class TSMChat
   {
      public var tcMChat_initialization:TCMChat_initialization;
      public var tcMChat_members:TCMChat_members;
      public var tcMChat_memberOnlineStatus:TCMChat_memberOnlineStatus;
      public var tcMChat_messages:TCMChat_messagesSendConfirmation;
      public var tcMChat_publicMessages:TCMChat_publicMessages;
      public var tcMChat_privateMessages:TCMChat_privateMessages;
      public var tcMChat_ui:TCMChat_ui;
      public var tcMChat_hasUnreadAllianceMsg:TCMChat_hasUnreadAllianceMsg;
      public var tcMChat_hasUnreadPrivateMsg:TCMChat_hasUnreadPrivateMsg;
      public var tcMChat_openPrivateChannel:TCMChat_openPrivateChannel;
      public var tcMChat_closeChannel:TCMChat_closeChannel;
      public var tcMChat:TCMChat;
   }
}