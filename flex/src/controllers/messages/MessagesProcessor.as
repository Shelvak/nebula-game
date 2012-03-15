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


      private var _buffer: Vector.<ServerRMO>;
      private var _sequence: RMOSequence;
      private var _nextSequenceNumber: int;

      public function MessagesProcessor() {
         reset();
      }

      public function reset(): void {
         _buffer = new Vector.<ServerRMO>();
         _sequence = new RMOSequence();
         _nextSequenceNumber = 0;
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

      private function get canProcessSequence(): Boolean {
         return _sequence.hasItems
                   && _sequence.firstNumber == _nextSequenceNumber;
      }

      private function processBuffer(count: uint): void {
         const logicExecutionManager: GameLogicExecutionManager
                  = GameLogicExecutionManager.getInstance();
         var processed: uint = 0;
         while (logicExecutionManager.executionEnabled
                   && (count == 0 || processed < count)
                   && (_buffer.length > 0 || canProcessSequence)) {
            var processSequence: Boolean = true;
            if (_buffer.length > 0) {
               const rmo: ServerRMO = _buffer.shift();
               if (rmo.inSequence) {
                  _sequence.insert(rmo);
               }
               else {
                  processMessage(rmo);
                  processed++;
                  processSequence = false;
               }
            }
            if (processSequence && canProcessSequence) {
               _nextSequenceNumber++;
               processMessage(_sequence.removeFirst());
               processed++;
            }
         }
      }

      private function processMessage(rmo: ServerRMO): void {
         if (rmo.isReply) {
            respMsgTracker.removeRMO(rmo);
         }
         else {
            msgLog.logMessage(
               rmo.action,
               "Processing message {0}. Seq: {1}.",
               [rmo.id, rmo.sequenceNumber],
               rmo.inSequence
            );
            new CommunicationCommand(
               rmo.action, rmo.parameters, true, false, rmo
            ).dispatch();
         }
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


import utils.remote.rmo.ServerRMO;


class RMOSequence
{
   private const _list: Vector.<ServerRMO> = new Vector.<ServerRMO>();

   public function insert(rmo: ServerRMO): void {
      const sequenceNumber: int = rmo.sequenceNumber;
      const length: int = _list.length;
      for (var insertAt: int = 0; insertAt < length; insertAt++) {
         if (sequenceNumber < _list[insertAt].sequenceNumber) {
            break;
         }
      }
      _list.splice(insertAt, 0, rmo);
   }

   public function removeFirst(): ServerRMO {
      return _list.shift();
   }

   public function get hasItems(): Boolean {
      return _list.length > 0;
   }

   public function get firstNumber(): int {
      return _list[0].sequenceNumber;
   }
}