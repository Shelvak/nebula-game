package tests._old.controllers.messages
{
   import com.developmentarc.core.utils.EventBroker;
   import utils.SingletonFactory;
   
   import controllers.messages.ServerCommandsDispatcher;
   import controllers.players.PlayersCommand;
   
   import net.digitalprimates.fluint.tests.TestCase;
   
   import utils.remote.rmo.ServerRMO;
   
   
   
   
   public class ServerCommandsDispatcherTest extends TestCase
   {
      private var rmo: ServerRMO;
      private var dispatcher: ServerCommandsDispatcher;
      
      
      protected override function setUp () :void
      {
         dispatcher = ServerCommandsDispatcher
            (SingletonFactory.getSingletonInstance (ServerCommandsDispatcher));
         rmo = new ServerRMO ();
      }
      
      
      [Test]
      public function dispatchCommandLogin () :void
      {
         rmo.controller = "player";
         rmo.action = PlayersCommand.LOGIN;
         rmo.parameters = {success: true};
         
         EventBroker.subscribe (
            PlayersCommand.LOGIN,
            asyncHandler (loginCommandRecieved, 1000, null, loginCommandTimeout)
         );
         
         dispatcher.dispatchCommand (rmo);
      }
      
      private function loginCommandRecieved (cmd: PlayersCommand, data: *) :void
      {
         assertTrue ("command.formServer should be true", cmd.fromServer);
         assertNotNull ("parameters should be present", cmd.parameters);
         assertTrue ("parameters.success should be true", cmd.parameters.success);
      }
      
      private function loginCommandTimeout (data: *) :void
      {
         fail ("ServerCommandsDispacher did not dispach login command");
      }
      
      
      [Test]
      public function dispatchCommandLogout () :void
      {
         rmo.controller = "player";
         rmo.action = PlayersCommand.LOGOUT;
         
         EventBroker.subscribe (
            PlayersCommand.LOGOUT,
            asyncHandler (logoutCommandRecieved, 1000, null, logoutCommandTimeout)
         );
         
         dispatcher.dispatchCommand (rmo);
      }
      
      private function logoutCommandRecieved (cmd: PlayersCommand, data: *) :void
      {
         assertTrue ("command.formServer should be true", cmd.fromServer);
         assertNull ("no parameters should be present", cmd.parameters);
      }
      
      private function logoutCommandTimeout (data :*) :void
      {
         fail ("ServerCommandsDispacher did not dispach logout command");
      }
      
      
      
      
      protected override function tearDown () :void
      {
         EventBroker.clearAllSubscriptions ();
         SingletonFactory.clearAllSingletonInstances ();
         
         dispatcher = null;
         rmo = null;
      }
   }
}