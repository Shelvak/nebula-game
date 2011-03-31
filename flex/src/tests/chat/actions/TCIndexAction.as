package tests.chat.actions
{
   import asmock.framework.Expect;
   
   import controllers.chat.ChatCommand;
   import controllers.chat.actions.IndexAction;

   
   public class TCIndexAction extends TCBaseChatAction
   {
      public function TCIndexAction()
      {
         super();
      };
      
      
      [Test]
      public function should_initialize_chat_singleton() : void
      {
         var action:IndexAction = new IndexAction();
         var members:Object = {
            "1": "mikism",
            "2": "jho",
            "3": "arturaz"
         };
         var channels:Object = {
            "galaxy": [1, 2, 3],
            "friends": [2, 3]
         };
         
         Expect.call(MCHAT.initialize(members, channels));
         
         mockRepository.replayAll();
         action.applyServerAction(
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