package components.notifications
{
   import models.ModelLocator;
   import models.notification.Notification;
   import models.notification.NotificationsCollection;
   import models.notification.events.NotificationsCollectionEvent;
   
   import mx.collections.IList;
   import mx.core.ClassFactory;
   import mx.events.FlexEvent;
   
   import spark.components.List;
   import spark.layouts.HorizontalAlign;
   import spark.layouts.VerticalLayout;
   
   /**
    * Lists specializes in displaying notifications.
    */
   public class NotificationsList extends List
   {
      public function NotificationsList()
      {
         super();
         itemRenderer = new ClassFactory(IRNotification);
         dataProvider = ModelLocator.getInstance().notifications;
         var layout:VerticalLayout = new VerticalLayout();
         layout.horizontalAlign = HorizontalAlign.JUSTIFY;
         layout.variableRowHeight = true;
         layout.gap = 0;
         this.layout = layout;
         addSelfEventHandlers();
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var _oldNotifs:NotificationsCollection = null;
      public override function set dataProvider(value:IList):void
      {
         if (super.dataProvider != value)
         {
            if (!_oldNotifs)
            {
               _oldNotifs = notifs;
            }
            super.dataProvider = value;
            f_dataProviderChanged = true;
         }
      }
      
      
      private var f_dataProviderChanged:Boolean = true;
      protected override function commitProperties() : void
      {
         super.commitProperties();
         
         if (f_dataProviderChanged)
         {
            if (_oldNotifs)
            {
               removeNotifsEventHandlers(_oldNotifs);
            }
            if (notifs)
            {
               addNotifsEventHandlers(notifs);
            }
         }
         
         f_dataProviderChanged = false;
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      protected override function itemSelected(index:int, selected:Boolean):void
      {
         super.itemSelected(index, selected);
         if (selected)
         {
            selectNotification(notifs.getNotifAt(index));
         }
      }
      
      
      private function get notifs() : NotificationsCollection
      {
         return dataProvider as NotificationsCollection;
      }
      
      
      private function selectNotification(notif:Notification) : void
      {
         selectedItem = notif;
         if (notif)
         {
            ensureIndexIsVisible(notifs.getItemIndex(notif));
            notifs.select(notif.id);
         }
         else
         {
            notifs.deselect();
         }
      }
      
      
      /* ###################### */
      /* ### EVENT HANDLERS ### */
      /* ###################### */
      
      
      private function addSelfEventHandlers() : void
      {
         addEventListener(FlexEvent.CREATION_COMPLETE, this_creationCompleteHandler);
      }
      
      
      private function addNotifsEventHandlers(notifs:NotificationsCollection) : void
      {
         notifs.addEventListener(NotificationsCollectionEvent.SELECTION_CHANGE, notifs_selectionChangeHandler);
      }
      
      
      private function removeNotifsEventHandlers(notifs:NotificationsCollection) : void
      {
         notifs.removeEventListener(NotificationsCollectionEvent.SELECTION_CHANGE, notifs_selectionChangeHandler);
      }
      
      
      private function this_creationCompleteHandler(event:FlexEvent) : void
      {
         selectNotification(notifs.selectedNotif);
      }
      
      
      private function notifs_selectionChangeHandler(event:NotificationsCollectionEvent) : void
      {
         if (selectedItem !== event.newNotif)
         {
            selectNotification(event.newNotif);
         }
      }
   }
}