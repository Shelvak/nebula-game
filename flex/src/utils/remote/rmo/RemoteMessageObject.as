package utils.remote.rmo
{
   import mx.formatters.NumberFormatter;

   /**
    * This is a Data Transfer Object (DTO) used by the
    * <code>ServerConnector</code> and other classes in the application for
    * exchanging data. This object has been created in order to have a standard
    * way for application communication with the server through
    * <code>ServerConnector</code>. This allows code to be changed only in RMO
    * classes if server-specific data format changes without altering the code
    * in rest of the application. 
    */   
   public class RemoteMessageObject
   {
      /**
       * Current time as a timestamp in a client machine.
       * 
       * @return Generated id as a string  
       */      
      public static function generateId () :String
      {
         return new Date().time.toString();
      }
      
      
      
      
      /**
       * Constructor.
       */
      public function RemoteMessageObject () {
         super ();
      }
      
      
      /**
       * Id of the message. 
       * 
       * @default null
       */      
      public var id: String = null;
      
      /**
       * Action that must be performed by the a controller when processing the data.
       * 
       * @default null
       */ 
      public var action: String = null;
      
      /**
       * Object that contains any additional data for processing.
       * 
       * @default null
       */
      public var parameters: Object = null;
   }
}