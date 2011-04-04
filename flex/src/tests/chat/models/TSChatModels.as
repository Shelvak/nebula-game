package tests.chat.models
{
   import tests.chat.models.channel.TSMChatChannel;
   import tests.chat.models.message.TSMChatMessage;
   
   
   [Suite]
   [RunWith("org.flexunit.runners.Suite")]
   public class TSChatModels
   {
      public var tsMChatChannel:TSMChatChannel;
      public var tsMChatMessage:TSMChatMessage;
      public var tcMChatMembersList:TCMChatMembersList;
   }
}