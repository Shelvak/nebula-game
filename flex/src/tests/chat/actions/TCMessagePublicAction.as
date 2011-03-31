package tests.chat.actions
{
   import asmock.framework.Expect;
   import asmock.framework.OriginalCallOptions;
   import asmock.framework.SetupResult;
   
   import controllers.chat.ChatCommand;
   import controllers.chat.actions.MessagePublicAction;
   
   import ext.hamcrest.object.equals;
   
   import models.chat.MChatMessage;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.object.hasProperties;
   
   
   public class TCMessagePublicAction extends TCBaseChatAction
   {
      public function TCMessagePublicAction()
      {
         super();
      };
      
      
      private var action:MessagePublicAction;
      
      
      [Before]
      public override function setUp() : void
      {
         super.setUp();
         action = new MessagePublicAction();
      };
      
      
      [After]
      public override function tearDown() : void
      {
         super.tearDown();
         action = null;
      };
      
      
      [Test]
      public function when_received_from_server_should_retrieve_message_from_pool_and_notify_MChat() : void
      {
         var params:Object = {
            "chan": "galaxy",
            "pid": 1,
            "msg": "This is an important message: give me my planet back!"
         };
         
         Expect.call(MCHAT.publicMessageReceive(null))
            .ignoreArguments()
            .doAction(function(message:MChatMessage) : void
            {
               assertThat( message, hasProperties ({
                  "channel": params.chan,
                  "playerId": params.pid,
                  "message": params.msg
               }));
            });
         
         mockRepository.replayAll();
         
         // No instances of MChatMessage should have been borrowed before the operation
         assertThat( MCHAT.messagePool.numActive, equals (0) );
         
         action.applyServerAction(new ChatCommand(ChatCommand.MESSAGE_PUBLIC, params, true));
         
         // One instance of MChatMessage should have been borrowed from the pool
         assertThat( MCHAT.messagePool.numActive, equals (1) );
         
         mockRepository.verifyAll();
      }; 
   }
}