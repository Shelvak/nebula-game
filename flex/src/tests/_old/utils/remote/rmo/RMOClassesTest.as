package tests._old.utils.remote.rmo
{
   import com.adobe.serialization.json.JSON;
   
   import net.digitalprimates.fluint.tests.TestCase;
   
   import utils.remote.proxy.ServerProxy;
   import utils.remote.rmo.*;
	
	public class RMOClassesTest extends TestCase
	{
	   // ################################################ //
	   // ### Testing message parsing form JSON to RMO ### //
	   // ################################################ //
	   
	   
	   [Test]
	   public function parseRecievedMessage () :void
	   {
         var rmo: ServerRMO = ServerRMO.parse (
            '{' + 
               '"action":"player|login",' + 
               '"id":"1242595414.890-771",' + 
               '"params":{' + 
                  '"name":"test",' + 
                  '"password":"test123"' + 
               '}' +
            '}'
         );
         
         assertEquals (
            "id should be the same",
            "1242595414.890-771", rmo.id
         );
         assertEquals (
            "action should be the same",
            "player|login", rmo.action
         );
         
         assertEquals (
            "parameter name should be the same",
            "test", rmo.parameters.name
         );
         assertEquals (
            "parameter password should be the same",
            "test123", rmo.parameters.password
         );
         
         assertNull (
            "replyTo should be null because this is not a response message",
            rmo.replyTo
         );
	   } 
	   
	   
	   [Test]
	   public function parseRecievedResponse () :void
	   {
         var rmo: ServerRMO = ServerRMO.parse (
            '{' +
               '"id":"546893165.789-568",' +
               '"reply_to":"1242595414.890-771"' +
            '}' 
         );
         
         assertEquals (
            "id should be the same",
            "546893165.789-568", rmo.id
         );
         assertEquals (
            "replyTo should be the same",
            "1242595414.890-771", rmo.replyTo
         );
         
         assertNull (
            "action should be null (this is a response message)",
            rmo.action
         );
         assertNull (
            "parameters should be null (this is a response message)",
            rmo.parameters
         );
      }
      
      
      
      
      // ############################################# //
      // ### Testing random generation of a RMO id ### //
      // ############################################# //
      
      
      [Test]
      public function randomIdGeneration () :void {
         var pattern: RegExp = /^[0-9]+$/;
         
         var id: String = RemoteMessageObject.generateId ();
         assertTrue (
            "id should be of a correct format (was " + id  + ")",
            pattern.test (id)
         );
      }
      
      
      [Test]
      public function clientRMOCreation () :void {
         var pattern: RegExp = /^[0-9]+$/;
         var rmo: ClientRMO = new ClientRMO (
            {username: "MikisM", password: "MikisM87"},
            null, null, "player|login"
         );
         
         assertNotNull (
            "id should be generated when ClientRMO isntace is created",
            rmo.id
         );
         assertTrue (
            "id should be of a correct format (was " + rmo.id + ")",
            pattern.test (rmo.id)
         );
         assertEquals ("action should be the same", "player|login", rmo.action);
         assertNotNull ("params should not be empty", rmo.parameters);
         assertEquals (
            "username should be the same",
            "MikisM", rmo.parameters.username
         );
         assertEquals (
            "password should be the same",
            "MikisM87", rmo.parameters.password
         );
      }
      
      
      
      
      // ########################################## //
      // ### Testing RMO classes public methods ### //
      // ########################################## //
      
      
      [Test]
      public function isReplyPropertyOfServerRMO () :void
      {
         var rmo: ServerRMO = new ServerRMO ();
         
         assertFalse (
            "isReply should be false when replyTo is null",
            rmo.isReply
         );
         
         rmo.replyTo = "123456.578-25";
         assertTrue (
            "isReply should be true when replyTo is not null",
            rmo.isReply
         );
      }
      
      
      [Test]
      public function matchingRMOsWhenDoNotMatch () :void
      {
         var clientRMO: ClientRMO = new ClientRMO (null, null, null);
         var serverRMO: ServerRMO = new ServerRMO ();
         
         assertFalse (
            "when serverRMO is not a response, RMOs should not match",
            serverRMO.matchesClientRMO (clientRMO)
         );
         
         serverRMO.replyTo = "546879.780-78";
         assertFalse (
            "when ServerRMO.replyTo is not the same as clientRMO.id, " + 
            "they should not match",
            serverRMO.matchesClientRMO (clientRMO)
         );
      }
      
      
      [Test]
      public function mathingRMOsWhenMatch () :void
      {
         var clientRMO: ClientRMO = new ClientRMO (null, null, null);
         var serverRMO: ServerRMO = new ServerRMO ();
         
         serverRMO.replyTo = clientRMO.id;
         
         assertTrue (
            "when ServerRMO.replyTo is the same as ClientRMO.id, " + 
            "they should match",
            serverRMO.matchesClientRMO (clientRMO)
         );
      }
      
      
      
      
      // ################################################# //
      // ### Testing ClientRMO encoding to JSON string ### //
      // ################################################# //
      
      
      [Test]
      public function encodeSimpleClientRMO () :void
      {
         var rmo: ClientRMO = new ClientRMO (
            {userName: "MikisM", password: "MikisM87"},
            null, null, "player|login"
         );
         
         var data: Object = JSON.decode (rmo.toJSON ());
         
         // Checking immediate properties existance
         testPropertyExistance(data, ServerProxy.SERVER_MESSAGE_ID_KEY);
         testPropertyExistance(data, "action");
         testPropertyExistance(data, "params");
         
         // Checking parameters existance
         testPropertyExistance(data.params, "user_name");
         testPropertyExistance(data.params, "password");
         
         // Checking immediate properties values
         assertEquals("action should be the same", "player|login", data.action);
         
         // Checking parameters' values
         testPropertiesValues(rmo.parameters, "userName", data.params, "user_name");
         testPropertiesValues(rmo.parameters, "password", data.params, "password");
      }
      
      
      private function testPropertyExistance (obj: Object, prop: String): void
      {
         assertNotNull (prop + " should exist", obj[prop]);
      }
      
      
      private function testPropertiesValues
            (objOrig: Object, propOrig: String,
             obj:     Object, prop:     String) :void
      {
         assertEquals (
            prop + " should be the same as " + propOrig,
            objOrig[propOrig], obj[prop]
         );
      }
	}
}