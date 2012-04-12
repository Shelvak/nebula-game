package tests.chat.actions
{
   import asmock.framework.Expect;
   import asmock.framework.constraints.Is;

   import controllers.chat.ChatCommand;
   import controllers.chat.actions.IndexAction;

   import models.chat.IChatJSCallbacksInvokerImpl;

   import tests.chat.classes.IChatJSCallbacksInvokerMock;


   public class TC_IndexAction extends TC_BaseChatAction
   {
      public function TC_IndexAction()
      {
         super();
      }
      
      [Test]
      public function should_initialize_chat_singleton() : void
      {
         const action: IndexAction = new IndexAction();
         const members: Object = {
            "1": "mikism",
            "2": "jho",
            "3": "arturaz"
         };
         const channels:Object = {
            "galaxy": [1, 2, 3],
            "friends": [2, 3]
         };
         
         Expect.call(MCHAT.initialize(null, null, null)).constraints([
            Is.typeOf(IChatJSCallbacksInvokerImpl),
            Is.same(members),
            Is.same(channels)
         ]);
         
         mockRepository.replayAll();
         action.applyAction(
            new ChatCommand(
               ChatCommand.INDEX,
               {"players": members, "channels": channels},
               true
            )
         );
         mockRepository.verifyAll();
      }
   }
}