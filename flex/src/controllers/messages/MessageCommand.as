package controllers.messages
{
   import com.developmentarc.core.actions.commands.AbstractCommand;
   
   import utils.remote.rmo.RemoteMessageObject;
   
   
   
   
   /**
    * Represents commands directly related with the server: sending and
    * receiving messages.
    */ 
   public class MessageCommand extends AbstractCommand
   {
      /**
       * This command is dispatched when a message originally initiated by
       * the server was received.
       * 
       * @eventType messageRecieved
       */
      public static const MESSAGE_RECEIVED: String = "messageReceived";
      
      /**
       * This command is dispatched when a response message (to some previously
       * sent client message to the server) is received.
       * 
       * @eventType responseRecieved
       */      
      public static const RESPONSE_RECEIVED: String = "responseReceived";
      
      /**
       * This command is dispatched when client has prepared a message to be
       * sent to the server.
       * 
       * @eventType sendMessage
       */      
      public static const SEND_MESSAGE: String = "sendMessage";
      
      
      
      
      private var _rmo: RemoteMessageObject = null;
      /**
       * Data that has to be sent to the server or has been received from the
       * server. 
       */      
      public function get rmo () :RemoteMessageObject
      {
         return _rmo;
      }
      
      
      
      
      /**
       * Constructor.
       * 
       * @param type Accual type of the command.
       * @param rmo Data that has been recieved form the server or has to be
       * sent to the server.
       */      
      public function MessageCommand (type: String, rmo: RemoteMessageObject)
      {
         super (type);
         _rmo = rmo;
      }
   }
}