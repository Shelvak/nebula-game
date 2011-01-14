package controllers.messages
{
   import com.developmentarc.core.datastructures.utils.HashTable;
   import com.developmentarc.core.utils.SingletonFactory;
   
   import components.popups.ErrorPopup;
   import components.popups.PopupCommand;
   
   import utils.DateUtil;
   import utils.Localizer;
   import utils.remote.IServerProxy;
   import utils.remote.ServerProxyInstance;
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
      
      
      private var _serverProxy:IServerProxy = ServerProxyInstance.getInstance();
      
      
      /**
       * A list of ClientRMOs that are waiting for response from the server.
       */
      private var pendingRMOs:Object = new Object();
      
      
      public function ResponseMessagesTracker ()
      {
      }
      
      
      /**
       * Removes all RMOs currently beeing tracked and stops the timer.
       * Call <code>start()</code> to start the timer again. 
       */
      public function reset() : void
      {
         for each (var record:PendingRMORecord in pendingRMOs.getAllItems())
         {
            if (record.rmo.model)
            {
               record.rmo.model.pending = false;
            }
         }
         pendingRMOs.removeAll();
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
            pendingRMOs.addItem(record.key, record);
            if (rmo.model)
            {
               rmo.model.pending = true;
            }
         }
      }
      
      
      /**
       * Removes a <code>ClientRMO</code> matching the given <code>ServerRMO</code> from the list and
       * calls a <code>result()</code> method of that RMO's responder's instance. Nothing happens if a
       * matching <code>ClientRMO</code> is not in the list.
       * 
       * @param rmo Instance of <code>ServerRMO</code> which is a response to one of the messages sent by
       * the client.
       * 
       * @return an instance of <code>ClientRMO</code> that matched given <code>ServerRMO</code> and was
       * removed form the queue or <code>null</code> if no match has been found.
       */		
      public function removeRMO(sRMO:ServerRMO) : ClientRMO
      {
         if (pendingRMOs.containsKey(sRMO.replyTo))
         {
            var record:PendingRMORecord = PendingRMORecord(pendingRMOs.getItem(sRMO.replyTo));
            pendingRMOs.remove(record.key);
            if (record.rmo.model)
            {
               record.rmo.model.pending = false;
            }
            record.rmo.responder.result ();
            return record.rmo;
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
         if (!_serverProxy.connected)
         {
            return;
         }
         
         var nowDate:Date = new Date();
         for each (var record:PendingRMORecord in pendingRMOs.getAllItems())
         {
            if (record.endTime < nowDate.time)
            {
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
         popup.closeHandler =
            function (cmd:String) : void
            {
               switch (cmd)
               {
                  case PopupCommand.RETRY:
                     MessagesProcessor.getInstance().sendMessage(record.rmo);
                     break;
                     
                  case PopupCommand.CANCEL:
                     record.rmo.model.pending = false;
                     break;
               }
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
class PendingRMORecord {
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
   public var rmo: ClientRMO = null;
   
   
   /**
    * Key of this record in the hash table. This is acually the same as
    * <code>rmo.id</code>. 
    */      
   public function get key () :String
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
   
    
   public function PendingRMORecord (rmo: ClientRMO)
   {
      this.rmo = rmo;
   }      
}

