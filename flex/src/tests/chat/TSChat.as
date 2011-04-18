package tests.chat
{
   import tests.chat.actions.TSChatActions;
   import tests.chat.models.TSChatModels;
   
   
   [Suite]
   [RunWith("org.flexunit.runners.Suite")]
   public class TSChat
   {
      public var tsChatActions:TSChatActions;
      public var tsChatModels:TSChatModels;
   }
}