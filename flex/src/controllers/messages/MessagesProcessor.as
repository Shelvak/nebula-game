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
      
      
      private var _respMsgTracker:ResponseMessagesTracker = ResponseMessagesTracker.getInstance();
      private var _serverProxy:IServerProxy = ServerProxyInstance.getInstance();
      
      
      public function MessagesProcessor()
      {
      }
      
      
      /**
       * Processes all messages received form the server since the last call to this method.
       */
      public function process() : void
      {
         var messages:Vector.<ServerRMO> = _serverProxy.getUnprocessedMessages();
         for each (var rmo:ServerRMO in messages)
         {
            if (rmo.isReply)
            {
               _respMsgTracker.removeRMO(rmo);
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
         _respMsgTracker.addRMO(rmo);
         _serverProxy.sendMessage(rmo);
      }
   }
}