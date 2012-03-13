package controllers.messages
{
   import controllers.CommunicationCommand;

   import utils.SingletonFactory;
   import utils.logging.MessagesLogger;
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
      public static function getInstance(): MessagesProcessor {
         return SingletonFactory.getSingletonInstance(MessagesProcessor);
      }

      private function get serverProxy(): IServerProxy {
         return ServerProxyInstance.getInstance();
      }

      private function get respMsgTracker(): ResponseMessagesTracker {
         return ResponseMessagesTracker.getInstance();
      }

      private function get msgLog(): MessagesLogger {
         return MessagesLogger.getInstance();
      }


      private var buffer: Vector.<ServerRMO>;

      public function MessagesProcessor() {
         reset();
      }

      /**
       * Processes all messages received form the server since the last call to
       * this method.
       *
       * @param count number of messages to process during this call. If 0 is
       * provided, all available messages will be processed.
       */
      public function process(count: uint = 0): void {
         var messages: Vector.<ServerRMO> = serverProxy.getUnprocessedMessages();
         if (messages != null) {
            buffer = buffer.concat(messages);
         }
         processBuffer(count);
      }

      private function processBuffer(count: uint): void {
         var processed: uint = 0;
         while ((count == 0 || processed < count) && buffer.length > 0) {
            const rmo: ServerRMO = buffer.shift();
            var keyword: String = rmo.action != null ? rmo.action : "";
            if (rmo.isReply) {
               respMsgTracker.removeRMO(rmo);
            }
            else {
               msgLog.logMessage(keyword, "Processing message {0}", [rmo.id]);
               new CommunicationCommand(
                  rmo.action, rmo.parameters, true, false, rmo
               ).dispatch();
            }
            processed++;
         }
      }

      /**
       * Sends a message to the server via <code>IServerProxy</code>.
       */
      public function sendMessage(rmo: ClientRMO): void {
         respMsgTracker.addRMO(rmo);
         serverProxy.sendMessage(rmo);
      }

      public function reset(): void {
         buffer = new Vector.<ServerRMO>();
      }
   }
}