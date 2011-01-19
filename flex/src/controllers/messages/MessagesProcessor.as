package controllers.messages
{
   import com.developmentarc.core.utils.SingletonFactory;
   
   import controllers.CommunicationCommand;
   
   import utils.remote.IServerProxy;
   import utils.remote.ServerProxyInstance;
   import utils.remote.rmo.ClientRMO;
   import utils.remote.rmo.ServerRMO;
   
   
   /**
    * Responsible for processing messages, received form server as well as sending messages to the server
    * via <code>IServerProxy</code>.
    */
   public class MessagesProcessor
   {
      public static function getInstance() : MessagesProcessor
      {
         return SingletonFactory.getSingletonInstance(MessagesProcessor);
      }
      
      
      private var RESP_MSG_TRACKER:ResponseMessagesTracker = ResponseMessagesTracker.getInstance();
      private var SERVER_PROXY:IServerProxy = ServerProxyInstance.getInstance();
      
      
      public function MessagesProcessor()
      {
      }
      
      
      /**
       * Processes all messages received form the server since the last call to this method.
       */
      public function process() : void
      {
         var messages:Vector.<ServerRMO> = SERVER_PROXY.getUnprocessedMessages();
         if (!messages)
         {
            return;
         }
         for each (var rmo:ServerRMO in messages)
         {
            if (rmo.isReply)
            {
               RESP_MSG_TRACKER.removeRMO(rmo);
            }
            else
            {
               new CommunicationCommand(rmo.action, rmo.parameters, true, false, rmo).dispatch();
            }
         }
      }
      
      
      /**
       * Sends a message to the server via <code>IServerProxy</code>.
       */
      public function sendMessage(rmo:ClientRMO) : void
      {
         RESP_MSG_TRACKER.addRMO(rmo);
         SERVER_PROXY.sendMessage(rmo);
      }
   }
}