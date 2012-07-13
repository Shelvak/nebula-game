package controllers.messages
{
   import controllers.CommunicationCommand;
   import controllers.startup.StartupInfo;

   import utils.Objects;

   import utils.SingletonFactory;
   import utils.execution.GameLogicExecutionManager;
   import utils.logging.MessagesLogger;
   import utils.remote.IServerProxy;
   import utils.remote.ServerProxyInstance;
   import utils.remote.rmo.ClientRMO;
   import utils.remote.rmo.ServerRMO;


   /**
    * Responsible for processing messages, received form server as well as
    * sending messages to the server via <code>IServerProxy</code>.
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


      private var _bufferOutOfOrder: Vector.<ServerRMO>;
      private var _bufferInOrder: RMOSequence;

      public function MessagesProcessor() {
         reset();
      }

      public function reset(): void {
         _bufferOutOfOrder = new Vector.<ServerRMO>();
         _bufferInOrder = new RMOSequence();

         _skipSequenceNumbers = new SequenceNumbersToSkip();
         _nextSequenceNumber = 0;

         clearWaitForAction();
      }

      private var _skipSequenceNumbers: SequenceNumbersToSkip;
      private var _nextSequenceNumber: int;
      private function get shouldSkipNextSequenceNumber(): Boolean {
         return _skipSequenceNumbers.has(_nextSequenceNumber);
      }

      private var _waitForAction: String;
      private function get waitingForAction(): Boolean {
         return _waitForAction != null;
      }
      private function clearWaitForAction(): void {
         _waitForAction = null;
      }
      private function setWaitForAction(value: String): void {
         _waitForAction = Objects.paramNotEmpty("value", value);
      }

      /**
       * Processes all messages received form the server since the last call to
       * this method.
       *
       * @param count number of messages to process during this call. If 0 is
       * provided, all available messages will be processed.
       */
      public function process(count: uint = 0): void {
         const messages: Vector.<ServerRMO> = serverProxy.getUnprocessedMessages();
         if (messages != null) {
            for each (var rmo: ServerRMO in messages) {
               if (waitingForAction && _waitForAction == rmo.action) {
                  _skipSequenceNumbers.put(rmo.sequenceNumber);
                  clearWaitForAction();
                  processMessage(rmo);
               }
               else {
                  if (rmo.inSequence) {
                     _bufferInOrder.insert(rmo);
                  }
                  else {
                     _bufferOutOfOrder.push(rmo);
                  }
               }
            }
         }
         if (!waitingForAction) {
            processBuffers(count);
         }
      }

      private function get canProcessInOrder(): Boolean {
         return _bufferInOrder.hasItems && _bufferInOrder.firstNumber == _nextSequenceNumber;
      }
      
      private function get canProcessOutOfOrder(): Boolean {
         return _bufferOutOfOrder.length > 0 && StartupInfo.getInstance().initializationComplete;
      }

      private function processBuffers(count: uint): void {
         const executionManager: GameLogicExecutionManager
            = GameLogicExecutionManager.getInstance();
         var processed: uint = 0;
         while (executionManager.executionEnabled
                   && (canProcessInOrder || canProcessOutOfOrder || shouldSkipNextSequenceNumber)
                   && (count == 0 || processed < count)) {
            if (shouldSkipNextSequenceNumber) {
               _skipSequenceNumbers.remove(_nextSequenceNumber);
               _nextSequenceNumber++;
            }
            else {
               if (canProcessInOrder) {
                  _nextSequenceNumber++;
                  processMessage(_bufferInOrder.removeFirst());
               }
               else {
                  processMessage(_bufferOutOfOrder.shift());
               }
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
         const waitFor: String = rmo.waitForAction;
         if (waitFor != null) {
            setWaitForAction(waitFor);
         }
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


class SequenceNumbersToSkip
{
   private const _numbers: Object = new Object();

   public function put(seqNum: int): void {
      _numbers[seqNum] = true;
   }

   public function has(seqNum: int): Boolean {
      return _numbers[seqNum] === true;
   }

   public function remove(seqNum: int): void {
      delete _numbers[seqNum];
   }
}