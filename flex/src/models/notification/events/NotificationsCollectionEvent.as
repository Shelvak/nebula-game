package models.notification.events
{
   import flash.events.Event;
   
   import models.notification.Notification;
   
   public class NotificationsCollectionEvent extends Event
   {
      /**
       * @eventType selectionChange
       * 
       * @see models.notification.NotificationsCollection
       */      
      public static const SELECTION_CHANGE:String = "selectionChange";
      
      
      /**
       * @eventType countersUpdated
       * 
       * @see models.notification.NotificationsCollection
       */      
      public static const COUNTERS_UPDATED:String = "countersUpdated";
      
      
      /**
       * Constructor.
       * 
       * @param oldNotif notification which was selected before this event has been dispached 
       * @param newNotif notification which has been selected
       */
      public function NotificationsCollectionEvent(type:String,
                                                   oldNotif:Notification = null,
                                                   newNotif:Notification = null)
      {
         super(type, false, false);
         _oldNotif = oldNotif;
         _newNotif = newNotif;
      }
      
      
      private var _oldNotif:Notification = null;
      /**
       * A notification which was selected before this event has been dispatched. <code>null</code> if there was
       * no notification selected.
       */
      public function get oldNotif() : Notification
      {
         return _oldNotif;
      }
      
      
      private var _newNotif:Notification = null;
      /**
       * A notification which has been selected when this event was dispached. <code>null</code> if no notification
       * has been selected (only <code>oldNotif</code> has been deselected).
       */
      public function get newNotif() : Notification
      {
         return _newNotif;
      }
   }
}