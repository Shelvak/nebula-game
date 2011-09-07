package controllers.messages
{
   import com.developmentarc.core.utils.EventBroker;
   
   import components.popups.ErrorPopup;
   
   import controllers.connection.ConnectionManager;
   
   import globalevents.GlobalEvent;
   
   import spark.components.Button;
   
   import utils.SingletonFactory;
   import utils.locale.Localizer;
   import utils.logging.targets.MessagesLogger;
   import utils.remote.rmo.ClientRMO;
   import utils.remote.rmo.ServerRMO;
   
   
   /**
    * Keeps track of messages (RMOs actually) sent to the server that need to
    * get a response (basicly that means all messages). Only one instance of
    * this class should be used throughout the application. 
    */   
   public class ResponseMessagesTracker
   {
      public static function getInstance() : ResponseMessagesTracker
      {
         return SingletonFactory.getSingletonInstance(ResponseMessagesTracker);
      }
      
      
      /**
       * Max time (in milliseconds) for a message to wait for a response. 
       */
      public static const MAX_WAIT_TIME:uint = 30 * 1000;
      
      
      private function get msgLog() : MessagesLogger {
         return MessagesLogger.getInstance();
      }
      
      private function get CONN_MANAGER() : ConnectionManager {
         return ConnectionManager.getInstance();
      }
      
      
      /**
       * A list of ClientRMOs that are waiting for response from the server.
       */
      private var pendingRMOs:Object = new Object();
      
      
      public function ResponseMessagesTracker ()
      {
         EventBroker.subscribe(GlobalEvent.APP_RESET, global_appResetHandler);
      }
      
      
      private function global_appResetHandler(event:GlobalEvent) : void
      {
         reset();
      }
      
      
      /**
       * Removes all RMOs currently beeing tracked.
       */
      public function reset() : void
      {
         for each (var record:PendingRMORecord in pendingRMOs)
         {
            if (record.rmo.model)
            {
               record.rmo.model.pending = false;
            }
         }
         pendingRMOs = new Object();
      }
      
      
      /**
       * Adds a given <code>ClientRMO</code> to a list of RMOs waiting for
       * response to be sent from the server. Does nothing if
       * <code>responder</code> property of the given RMO is not set.
       * 
       * @param rmo Instance of <code>ClientRMO</code> that needs to wait for
       * response from the server and get notified when that happens.  
       */	   
      public function addRMO(rmo:ClientRMO) : void
      {
         if (rmo.responder != null)
         {
            var record:PendingRMORecord = new PendingRMORecord(rmo);
            record.endTime = new Date().time + MAX_WAIT_TIME;
            pendingRMOs[record.key] = record;
            if (rmo.model)
            {
               rmo.model.pending = true;
            }
         }
      }
      
      
      /**
       * Removes a <code>ClientRMO</code> matching the given <code>ServerRMO</code> from the list and
       * calls a <code>result()</code> method on that RMO's responder's instance if <code>sRMO.failed ==
       * false</code> or <code>cancel()</code> otherwise. Nothing happens if a matching <code>ClientRMO</code>
       * is not in the list.
       * 
       * @param rmo Instance of <code>ServerRMO</code> which is a response to one of the messages sent by
       * the client.
       * 
       * @return an instance of <code>ClientRMO</code> that matched given <code>ServerRMO</code> and was
       * removed form the queue or <code>null</code> if no match has been found.
       */
      public function removeRMO(sRMO:ServerRMO) : ClientRMO
      {
         if (pendingRMOs[sRMO.replyTo])
         {
            var record:PendingRMORecord = PendingRMORecord(pendingRMOs[sRMO.replyTo]);
            var rmo:ClientRMO = record.rmo;
            delete pendingRMOs[record.key];
            if (rmo.model)
            {
               rmo.model.pending = false;
            }
            msgLog.logMessage(rmo.action, "Processing response message to {0}", rmo.id);
            if (sRMO.failed)
               rmo.responder.cancel(rmo);
            else
               rmo.responder.result(rmo);
            return rmo;
         }
         return null;
      }
      
      
      /**
       * Checks if any messages have not received response in time and if that is true, takes appropriate
       * action (shows error popup and so on).
       */      
      public function checkWaitingMessages() : void
      {
         // Don't do anything if we are disconnected or user might bump into a situation like this: while
         // deciding wether to try roconnecting or not user gets also a response timeout popup.
         if (!CONN_MANAGER.connected)
         {
            return;
         }
         
         var nowDate:Date = new Date();
         for each (var record:PendingRMORecord in pendingRMOs)
         {
            if (record.endTime < nowDate.time)
            {
               reset();
               CONN_MANAGER.responseTimeout();
            }
         }
      }
      
      
      /**
       * A timeout means that we need to reset the app on users behalf. Just disconnect first if we
       */
      private function recordTimeout(record:PendingRMORecord) : PendingRMORecord
      {
         var popup: ErrorPopup = new ErrorPopup();
         popup.title   = Localizer.string("Popups", "title.responseTimeout");
         popup.message = Localizer.string("Popups", "message.responseTimeout");
         popup.retryButtonLabel  = Localizer.string("Popups", "label.retry");
         popup.cancelButtonLabel = Localizer.string("Popups", "label.cancel");
         popup.retryButtonClickHandler =
            function (button:Button) : void
            {
               MessagesProcessor.getInstance().sendMessage(record.rmo);
            };
         popup.cancelButtonClickHandler =
            function (button:Button) : void
            {
               record.rmo.model.pending = false;
            };
         popup.show();
         
         return record;
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
   public var endTime:Number = 0;
   
   
   /**
    * Instance of <code>ClientRMO</code> which needs to be notified when
    * response has been received form the server. 
    */      
   public var rmo:ClientRMO = null;
   
   
   /**
    * Key of this record in the hash table. This is acually the same as
    * <code>rmo.id</code>. 
    */      
   public function get key() : String
   {
      if (rmo != null)
      {
         return rmo.id;
      }
      else
      {
         return "";
      }
   }
   
    
   public function PendingRMORecord(rmo:ClientRMO)
   {
      this.rmo = rmo;
   }
}

