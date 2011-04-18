package tests.chat.models
{
   import tests.chat.models.channel.TSMChatChannel;
   import tests.chat.models.chat.TSMChat;
   
   
   [Suite]
   [RunWith("org.flexunit.runners.Suite")]
   public class TSChatModels
   {
      public var tcMChatMembersList:TCMChatMembersList;
      public var tcMChatMember:TCMChatMember;
      public var tcMChatChannelsList:TCMChatChannelsList;
      public var tcMChatMessage:TCMChatMessage;
      public var tsMChatChannel:TSMChatChannel;
      public var tsMChat:TSMChat;
   }
}