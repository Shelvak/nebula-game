package tests._old.utils.remote
{
   import com.developmentarc.core.utils.EventBroker;
   
   import controllers.startup.StartupInfo;
   
   import globalevents.GConnectionEvent;
   
   import models.ModelLocator;
   
   import net.digitalprimates.fluint.tests.TestCase;
   
   import utils.remote.ServerConnector;
   
   
   
   
   public class ServerConnectorTest extends TestCase
   {
      private var ML:ModelLocator = ModelLocator.getInstance();
      private var con: ServerConnector;
      
      
      protected override function setUp () :void
      {
         EventBroker.clearAllSubscriptions ();
         con = new ServerConnector ();
         ML.startupInfo = new StartupInfo();
         ML.startupInfo.server = "localhost";
      }
      
      
      protected override function tearDown() : void
      {
         con = null;
      }
      
      
      [Test]
      public function tryConnecting () :void
      {
         EventBroker.subscribe (
            GConnectionEvent.CONNECTION_ESTABLISHED,
            asyncHandler (connected, 1000, null, connectionTimeout)
         );
         con.connect ();
      }
      
      private function connected (cmd: GConnectionEvent, data: *) :void
      {
         // Connection is ok. Now we can disconnect
         con.disconnect ();
      }
      
      private function connectionTimeout (data: *) :void
      {
         fail ("Connection timeout: this should not have happened.");
      }
   }
}