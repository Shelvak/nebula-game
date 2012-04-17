package models.chat
{
   public interface IChatJSCallbacksInvoker
   {
      function hasUnreadAllianceMessages(title:String): void;
      function allianceMessagesRead(): void;
      function hasUnreadPrivateMessages(title:String):void;
      function privateMessagesRead(): void;
   }
}
