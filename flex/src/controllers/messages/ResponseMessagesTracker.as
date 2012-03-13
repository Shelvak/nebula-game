package controllers.messages
{
   import controllers.connection.ConnectionManager;

   import mx.utils.ObjectUtil;

   import utils.SingletonFactory;
   import utils.logging.MessagesLogger;
   import utils.remote.rmo.ClientRMO;
   import utils.remote.rmo.ServerRMO;


   /**
    * Keeps track of messages (RMOs actually) sent to the server that need to
    * get a response (basically that means all messages). Only one instance of
    * this class should be used throughout the application.
    */
   public class ResponseMessagesTracker
   {
      public static function getInstance(): ResponseMessagesTracker {
         return SingletonFactory.getSingletonInstance(ResponseMessagesTracker);
      }


      /**
       * Max time (in milliseconds) for a message to wait for a response.
       */
      public static const MAX_WAIT_TIME: uint = 30 * 1000;


      private function get msgLog(): MessagesLogger {
         return MessagesLogger.getInstance();
      }

      private function get connManager(): ConnectionManager {
         return ConnectionManager.getInstance();
      }


      private var _pendingRMOs: Object = new Object();

      public function ResponseMessagesTracker() {
      }

      /**
       * Removes all RMOs currently being tracked.
       */
      public function reset(): void {
         for each (var record: PendingRMORecord in _pendingRMOs) {
            if (record.rmo.model) {
               record.rmo.model.pending = false;
            }
         }
         _pendingRMOs = new Object();
      }


      /**
       * Adds a given <code>ClientRMO</code> to a list of RMOs waiting for
       * response to be sent from the server. Does nothing if
       * <code>responder</code> property of the given RMO is not set.
       *
       * @param rmo Instance of <code>ClientRMO</code> that needs to wait for
       * response from the server and get notified when that happens.
       * <code>id</code> property will be modified if there already is another
       * RMO waiting for a response from the server with the same id.
       */
      public function addRMO(rmo: ClientRMO): void {
         if (rmo.responder != null) {
            var record: PendingRMORecord = new PendingRMORecord(rmo);

            // in case we already have a waiting message with the same id
            // we have to make id of the given RMO to be unique
            var id: Number = Number(rmo.id);
            while (_pendingRMOs[record.key] !== undefined) {
               id++;
               rmo.id = id.toString();
            }

            record.endTime = new Date().time + MAX_WAIT_TIME;
            _pendingRMOs[record.key] = record;
            if (rmo.model != null) {
               rmo.model.pending = true;
            }
         }
      }


      /**
       * Removes a <code>ClientRMO</code> matching the given
       * <code>ServerRMO</code> from the list and calls a <code>result()</code>
       * method on that RMO's responder's instance if <code>sRMO.failed ==
       * false</code> or <code>cancel()</code> otherwise. Nothing happens if a
       * matching <code>ClientRMO</code> is not in the list.
       *
       * @param sRMO Instance of <code>ServerRMO</code> which is a response to
       * one of the messages sent by the client.
       *
       * @return an instance of <code>ClientRMO</code> that matched given
       * <code>ServerRMO</code> and was removed form the queue or
       * <code>null</code> if no match has been found.
       */
      public function removeRMO(sRMO: ServerRMO): ClientRMO {
         if (_pendingRMOs[sRMO.replyTo]) {
            const record: PendingRMORecord = PendingRMORecord(_pendingRMOs[sRMO.replyTo]);
            const rmo: ClientRMO = record.rmo;
            delete _pendingRMOs[record.key];
            if (rmo.model) {
               rmo.model.pending = false;
            }
            if (sRMO.failed) {
               msgLog.logMessage(
                  rmo.action,
                  "Processing response message to {0}. Success: false. "
                     + "Server error: {1}",
                  [rmo.id, ObjectUtil.toString(sRMO.error)]
               );
               rmo.responder.cancel(rmo, sRMO);
            }
            else {
               msgLog.logMessage(
                  rmo.action,
                  "Processing response message to {0}. Success: true.",
                  [rmo.id]
               );
               rmo.responder.result(rmo);
            }
            return rmo;
         }
         return null;
      }


      /**
       * Checks if any messages have not received response in time and if that is true, takes appropriate
       * action (shows error popup and so on).
       */
      public function checkWaitingMessages(): void {
         // Don't do anything if we are disconnected or user might bump into a
         // situation like this: while deciding whether to try reconnecting or
         // not user gets also a response timeout popup.
         if (!connManager.connected) {
            return;
         }

         var nowDate: Date = new Date();
         for each (var record: PendingRMORecord in _pendingRMOs) {
            if (record.endTime < nowDate.time) {
               reset();
               connManager.responseTimeout();
            }
         }
      }
   }
}


import utils.remote.rmo.ClientRMO;


/**
 * Instances of this type are acually kept in _pendingRMOs hash table.
 */
class PendingRMORecord
{
   /**
    * Time (in milliseconds) when this record will timeout.
    *
    * @default 0
    */
   public var endTime: Number = 0;

   /**
    * Instance of <code>ClientRMO</code> which needs to be notified when
    * response has been received form the server.
    */
   public var rmo: ClientRMO = null;

   /**
    * Key of this record in the hash table. This is acually the same as
    * <code>rmo.id</code>.
    */
   public function get key(): String {
      if (rmo != null) {
         return rmo.id;
      }
      else {
         return "";
      }
   }

   public function PendingRMORecord(rmo: ClientRMO) {
      this.rmo = rmo;
   }
}
