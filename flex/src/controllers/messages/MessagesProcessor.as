package controllers.messages
{
   import controllers.CommunicationCommand;

   import utils.SingletonFactory;
   import utils.execution.GameLogicExecutionManager;
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


      private var _deferredRMOs: Object;
      private var _buffer: Vector.<ServerRMO>;

      public function MessagesProcessor() {
         reset();
      }

      public function reset(): void {
         _deferredRMOs = new Object();
         _buffer = new Vector.<ServerRMO>();
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
            _buffer = _buffer.concat(messages);
         }
         processBuffer(count);
      }

      private function processBuffer(count: uint): void {
         const logicExecutionManager: GameLogicExecutionManager
                  = GameLogicExecutionManager.getInstance();
         var processed: uint = 0;
         while (logicExecutionManager.executionEnabled
                   && (count == 0 || processed < count)
                   && _buffer.length > 0) {
            const rmo: ServerRMO = _buffer.shift();
            if (rmo.isReply) {
               respMsgTracker.removeRMO(rmo);
            }
            else {
               processMessage(rmo);
            }
            processed++;
         }
      }

      private function processMessage(rmo: ServerRMO): void {
         msgLog.logMessage(rmo.action, "Processing message {0}", [rmo.id]);
         new CommunicationCommand(rmo.action, rmo.parameters, true, false, rmo)
            .dispatch();
      }

      /**
       * Sends a message to the server via <code>IServerProxy</code>.
       */
      public function sendMessage(rmo: ClientRMO): void {
         respMsgTracker.addRMO(rmo);
         serverProxy.sendMessage(rmo);
      }
   }
}