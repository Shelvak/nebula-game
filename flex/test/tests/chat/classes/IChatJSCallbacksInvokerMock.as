package tests.chat.classes
{
   import models.chat.IChatJSCallbacksInvoker;


   public class IChatJSCallbacksInvokerMock implements IChatJSCallbacksInvoker
   {
      public function IChatJSCallbacksInvokerMock() {
         reset()
      }

      public function reset(): void {
         hasUnreadPrivateMessagesParam = null;
         hasUnreadAllianceMessagesParam = null;
         privateMessagesReadCalled = false;
         allianceMessagesReadCalled = false;
      }

      public var hasUnreadAllianceMessagesParam: String;
      public function hasUnreadAllianceMessages(title: String): void {
         hasUnreadAllianceMessagesParam = title;
      }

      public var allianceMessagesReadCalled: Boolean;
      public function allianceMessagesRead(): void {
         allianceMessagesReadCalled = true;
      }

      public var hasUnreadPrivateMessagesParam: String;
      public function hasUnreadPrivateMessages(title: String): void {
         hasUnreadPrivateMessagesParam = title;
      }

      public var privateMessagesReadCalled: Boolean;
      public function privateMessagesRead(): void {
         privateMessagesReadCalled = true;
      }
   }
}
