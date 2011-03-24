package controllers
{
   import globalevents.GlobalEvent;
   
   import utils.remote.rmo.RemoteMessageObject;
   
   
   
   
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
       * Indicates if this command was ininiated by the server (true) or from the client (false).
       * 
       * @default false
       */
      public var fromServer: Boolean = false;
      
      
      /**
       * Set only if <code>fromServer</code> is <code>true</code>.
       */
      public var rmo:RemoteMessageObject = null;
      
      
      /**
       * Constructor.
       */
      public function CommunicationCommand(type:String,
                                           parameters:Object = null,
                                           fromServer:Boolean = false,
                                           eagerDispatch:Boolean = false,
                                           rmo:RemoteMessageObject = null)
      {
         this.parameters = parameters;
         this.fromServer = fromServer;
         this.rmo = rmo;
         super(type,eagerDispatch);
      }
   }
}