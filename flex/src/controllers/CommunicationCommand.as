package controllers
{
   import globalevents.GlobalEvent;
   
   
   
   
   /**
    * Commands that initiate actions that include sending and receiving messages
    * to and from the server should extends this class.
    */
   public class CommunicationCommand extends GlobalEvent
   {
      /**
       * Data that is passed to the controller by dispaching this command.
       * 
       * @default null 
       */
      public var parameters: Object = null;
      
      
      /**
       * Indicates if this command was ininiated by the server
       * (true) or from the client (false).
       * 
       * @default false
       */
      public var fromServer: Boolean = false;
      
      
      /**
       * Constructor.
       */
      public function CommunicationCommand
         (type:String,
          parameters:Object=null,
          fromServer:Boolean=false,
          eagerDispatch:Boolean=false)
      {
         this.parameters = parameters;
         this.fromServer = fromServer;
         super(type,eagerDispatch);
      }
   }
}