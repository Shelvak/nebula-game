package tests.chat
{
   import tests.chat.actions.TS_ChatActions;
   import tests.chat.models.TS_ChatModels;
   
   
   [Suite]
   [RunWith("org.flexunit.runners.Suite")]
   public class TS_Chat
   {
      public var ts_ChatActions:TS_ChatActions;
      public var ts_ChatModels:TS_ChatModels;
   }
}