package utils.remote.rmo
{
   import com.adobe.serialization.json.JSON;
   import com.adobe.serialization.json.JSONParseError;
   
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
      public static function parse(jsonString: String): ServerRMO {
         try {
            const data: Object = JSON.decode(jsonString);
         }
         catch (err: JSONParseError) {
            err.message = "Error while parsing JSON string:"
                             + "\n" + jsonString
                             + "\nOriginal error message: " + err.message;
            throw err;
         }
         const rmo: ServerRMO = new ServerRMO();
         if (data["reply_to"] !== undefined) {
            rmo.replyTo = data["reply_to"];
         }
         if (data["seq"] !== undefined) {
            rmo.sequenceNumber = data["seq"];
         }
         if (data["failed"] !== undefined) {
            rmo.failed = data["failed"];
            rmo.error = data["error"];
         }
         else {
            rmo.action = data["action"];
            rmo.parameters = PropertiesTransformer.objectToCamelCase(data["params"]);
         }
         rmo.id = data.id;
         return rmo;
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
       * Not negative number means that this message can be processed only after
       * all other messages with <code>sequenceNumber &lt; this.sequenceNumber</code>
       * have been processed.
       */
      public var sequenceNumber: int = -1;

      /**
       * Only relevant for reply messages (<code>isReply == true</code>).
       * <code>true</code> means that request has failed because of game logic error (probably caused by
       * sync problems) and all actions taken by the client should be rolled back.
       *
       * @default false
       */
      public var failed: Boolean = false;

      /**
       * Only relevant for reply messages. This is not null and contains server
       * error information if <code>failed == true</code>.
       */
      public var error: Object = null;

      /**
       * Indicates if this instance of <code>ServerRMO</code> is acually a
       * response to a message sent to the server by the client.
       *
       * @default false
       */
      public function get isReply(): Boolean {
         return replyTo != null;
      }

      /**
       * Is this message part of sequence of a few messages that must be
       * processed in order?
       */
      public function get inSequence(): Boolean {
         return sequenceNumber > -1;
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
      public function matchesClientRMO(rmo: ClientRMO): Boolean {
         if (isReply && replyTo == rmo.id) {
            return true
         }
         return false
      }
   }
}