package utils.remote.rmo
{
   import com.adobe.serialization.json.JSON;
   
   import utils.PropertiesTransformer;




   /**
   * This type of RMO is recieved from the server.
   * 
   * @copy RemoteMessageObject
   */
   public class ServerRMO extends RemoteMessageObject
   {
      /**
       * Creates and returns instance of <code>ServerRMO</code> with properties
       * set. Data is taken form the given JSON string.
       * 
       * @param jsonString JSON string that contains data to be extracted.
       */
      public static function parse (jsonString: String) :ServerRMO
      {
         var data: Object = JSON.decode (jsonString);
         var rmo: ServerRMO = new ServerRMO ();
         
         if (data.hasOwnProperty ("reply_to"))
         {
            rmo.replyTo = data.reply_to;
         }
         else
         {
            var action: Array = String (data.action).split ("|");
            rmo.controller = PropertiesTransformer.propToCamelCase(action[0]);
            rmo.action     = PropertiesTransformer.propToCamelCase(action[1]);
            rmo.parameters = PropertiesTransformer.objectToCamelCase(data.params);
         }
         rmo.id = data.id;
         return rmo;
      }
      
      
      /**
       * Constructor.
       */
      public function ServerRMO()
      {
         super();
      }
      
      /**
       * Id of the message that has been sent to the server prior getting
       * response to that message. <code>ServerRMO</code> instance that have
       * not got this property set to null is treated as response to the message
       * sent by the client to the server.
       * 
       * @default null 
       */
      public var replyTo: String = null;
      
      /**
       * Indicates if this instance of <code>ServerRMO</code> is acually a
       * response to a message sent to the server by the client.
       * 
       * @default false
       */
      public function get isReply () :Boolean
      {
         return (replyTo != null);
      }
      
      /**
       * Use this to find out if this insntance of <code>ServerRMO</code>
       * mathes - is response to - the given instance of
       * <code>ClientRMO</code>.
       * 
       * @param rmo Instance of <code>ClientRMO</code> that has to be checked
       * againts this instance.
       * 
       * @return true if this <code>ServerRMO</code> is a response to the
       * given <code>ClientRMO</code>, false - otherwise.
       */
      public function matchesClientRMO (rmo: ClientRMO) :Boolean
      {
         if (isReply && replyTo == rmo.id)
         {
            return true
         }
         return false
      }
   }
}