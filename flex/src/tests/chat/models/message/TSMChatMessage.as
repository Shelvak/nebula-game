package tests.chat.models.message
{
   [Suite]
   [RunWith("org.flexunit.runners.Suite")]
   public class TSMChatMessage
   {
      public var tcMChatMessage:TCMChatMessage;
      public var tcChatMessageProcessor:TCChatMessageProcessor;
      public var tcPrivateMessageProcessor:TCPrivateMessageProcessor;
      public var tcPublicMessageProcessor:TCPublicMessageProcessor;
   }
}