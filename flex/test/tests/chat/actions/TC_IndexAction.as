package tests.chat.actions
{
   import asmock.framework.Expect;
   
   import controllers.chat.ChatCommand;
   import controllers.chat.actions.IndexAction;

   
   public class TC_IndexAction extends TC_BaseChatAction
   {
      public function TC_IndexAction()
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