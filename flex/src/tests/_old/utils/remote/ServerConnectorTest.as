package tests._old.utils.remote
{
   import com.developmentarc.core.utils.EventBroker;
   
   import globalevents.GConnectionEvent;
   
   import net.digitalprimates.fluint.tests.TestCase;
   
   import utils.remote.ServerConnector;
   
   
   
   
   public class ServerConnectorTest extends TestCase
   {
      private var con: ServerConnector;
      
      
      protected override function setUp () :void
      {
         EventBroker.clearAllSubscriptions ();
         con = new ServerConnector ();
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