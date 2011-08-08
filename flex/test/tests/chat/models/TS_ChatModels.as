package tests.chat.models
{
   import tests.chat.models.channel.TS_MChatChannel;
   import tests.chat.models.chat.TS_MChat;
   
   
   [Suite]
   [RunWith("org.flexunit.runners.Suite")]
   public class TS_ChatModels
   {
      public var tc_MChatMembersList:TC_MChatMembersList;
      public var tc_MChatMember:TC_MChatMember;
      public var tc_MChatChannelsList:TC_MChatChannelsList;
      public var tc_MChatMessage:TC_MChatMessage;
      public var ts_MChatChannel:TS_MChatChannel;
      public var ts_MChat:TS_MChat;
   }
}