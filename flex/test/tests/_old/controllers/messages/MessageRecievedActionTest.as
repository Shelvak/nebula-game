package tests._old.controllers.messages
{
   import com.developmentarc.core.utils.EventBroker;
   
   import controllers.messages.MessageCommand;
   import controllers.messages.actions.MessageReceivedAction;
   import controllers.players.PlayersCommand;
   
   import net.digitalprimates.fluint.tests.TestCase;
   
   import utils.remote.rmo.ServerRMO;
   
   
   
   
   public class MessageRecievedActionTest extends TestCase
   {
      private var action: MessageReceivedAction;
      private var rmo: ServerRMO;
      
      
      protected override function setUp () :void
      {
         action = new MessageReceivedAction ();
      }
      
      
      [Test]
      public function applyAction () :void
      {
         rmo = new ServerRMO ();
         rmo.controller = "player";
         rmo.action = "login";
         rmo.parameters = {success: true};
         
         EventBroker.subscribe (
            PlayersCommand.LOGIN,
            asyncHandler (loginCommandRecieved, 1000, null, loginCommandTimeout)
         );
         
         action.applyAction
            (new MessageCommand (MessageCommand.MESSAGE_RECEIVED, rmo));
      }
      
      private function loginCommandRecieved (cmd: PlayersCommand, data: *) :void
      {
         assertTrue (
            "command should be marked as if it's been initiated by the server",
            cmd.fromServer
         );
         assertNotNull (
            "parameters should exist",
            cmd.parameters
         );
         assertTrue (
            "success parameter should have not changed",
            cmd.parameters.success
         );
      }
      
      private function loginCommandTimeout (data: *) :void
      {
         fail ("login command should have been dispatched");
      }
      
      
      protected override function tearDown () :void
      {
         EventBroker.clearAllSubscriptions ();
         
         rmo = null;
      }
   }
}