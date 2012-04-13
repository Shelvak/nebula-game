package models.chat
{
   import flash.external.ExternalInterface;


   public class IChatJSCallbacksInvokerImpl implements IChatJSCallbacksInvoker
   {
      public function hasUnreadAllianceMessages(title: String): void {
         ExternalInterface.call("allianceChannelHasMessages", title);
      }

      public function allianceMessagesRead(): void {
         ExternalInterface.call("allianceChannelRead");
      }

      public function hasUnreadPrivateMessages(title: String): void {
         ExternalInterface.call("unreadPrivateMessages", title);
      }

      public function privateMessagesRead(): void {
         ExternalInterface.call("privateMessagesRead");
      }
   }
}
