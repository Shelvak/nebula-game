package models.notification
{
   import controllers.ui.NavigationController;
   
   import models.notification.events.NotificationEvent;
   import models.notification.events.NotificationsCollectionEvent;
   
   import mx.collections.Sort;
   import mx.collections.SortField;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   
   import models.ModelsCollection;
   
   
   /**
    * Dispatched when notification has been selected or deselected. If both are true, only one event will be
    * dispatched. 
    * 
    * @eventType models.notification.events.NotificationsCollectionEvent.SELECTION_CHANGE
    */
   [Event(name="selectionChange", type="models.notification.events.NotificationsCollectionEvent")]
   
   
   /**
    * Dispatched when any of counter properties (<code>notifsTotal</code>,
    * <code>newNotifsTotal</code> and <code>unreadNotifsTotal</code>) where updated.
    * 
    * @eventType models.notification.events.NotificationsCollectionEvent.COUNTERS_UPDATED
    */
   [Event(name="countersUpdated", type="models.notification.events.NotificationsCollectionEvent")]
   
   
   /**
    * List of notifications.
    */
   public class NotificationsCollection extends ModelsCollection
   {
      /**
       * @see mx.collections.ArrayCollection#ArrayCollection()
       */
      public function NotificationsCollection(source:Array = null)
      {
         super(source);
         registerSelfEventHandlers();
         applyCreatedAtSort();
         updateCounters();
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      [Bindable(event="countersUpdated")]
      public function get notifsTotal() : int
      {
         return source.length;
      }
      
      
      [Bindable(event="countersUpdated")]
      public function get hasNotifs() : Boolean
      {
         return notifsTotal > 0;
      }
      
      
      private var _newNotifsTotal:int = 0;
      [Bindable(event="countersUpdated")]
      public function get newNotifsTotal() : int
      {
         return _newNotifsTotal;
      }
      
      
      [Bindable(event="countersUpdated")]
      public function get hasNewNotifs() : Boolean
      {
         return _newNotifsTotal > 0;
      }
      
      
      private var _unreadNotifsTotal:int = 0;
      [Bindable(event="countersUpdated")]
      public function get unreadNotifsTotal() : int
      {
         return _unreadNotifsTotal;
      }
      
      
      [Bindable(event="countersUpdated")]
      public function get hasUnreadNotifs() : Boolean
      {
         return _unreadNotifsTotal > 0;
      }
      
      
      private var _selectedNotif:Notification = null;
      [Bindable(event="selectionChange")]
      /**
       * Currrently selected notification.
       */
      public function get selectedNotif() : Notification
      {
         return _selectedNotif;
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      /**
       * Same as: <code>getItemAt(index, prefetch) as Notification</code>
       * 
       * @see #getItemAt()
       */
      public function getNotifAt(index:int, prefetch:int = 0) : Notification
      {
         return getItemAt(index, prefetch) as Notification;
      }
      
      
      public override function addItemAt(item:Object, index:int) : void
      {
         super.addItemAt(item, index);
         registerNotifEventHandlers(item as Notification);
      }
      
      
      public override function removeItemAt(index:int):Object
      {
         var notifRemoved:Notification = super.removeItemAt(index) as Notification;
         removeNotifEventHandlers(notifRemoved);
         return notifRemoved;
      }
      
      
      public function applyStarredFilter(starred:Boolean) : void
      {
         filterFunction = function(notif:Notification) : Boolean
         {
            return notif.starred == starred;
         };
         refresh();
         updateSelectionAfterFilter();
      }
      
      
      public function applyReadFilter(read:Boolean) : void
      {
         filterFunction = function(notif:Notification) : Boolean
         {
            return notif.read == read;
         }
         refresh();
         updateSelectionAfterFilter();
      }
      
      
      public function removeFilter() : void
      {
         filterFunction = null;
         refresh();
      }
      
      
      public function removeSort() : void
      {
         sort = null;
         refresh();
      }
      
      
      public function select(id:int) : void
      {
         selectImpl(findModel(id) as Notification);
      }
      
      
      public function deselect() : void
      {
         selectImpl();
      }
      
      
      /**
       * Navigates to notifications screen and selects notification with a given id.
       * 
       * @param id id on notification to select
       */
      public function show(id:int) : void
      {
         NavigationController.getInstance().showNotifications();
         select(id);
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function applyCreatedAtSort() : void
      {
         var sort:Sort = new Sort();
         sort.fields = [
            new SortField("createdAt", false, true)
         ];
         this.sort = sort;
         refresh();
      }
      
      
      private function updateSelectionAfterFilter() : void
      {
         if (_selectedNotif && !contains(_selectedNotif))
         {
            deselect();
         }
      }
      
      
      private function selectImpl(newNotif:Notification = null) : void
      {
         var oldNotif:Notification = _selectedNotif;
         if (newNotif != oldNotif)
         {
            _selectedNotif = newNotif;
            if (_selectedNotif)
            {
               _selectedNotif.doRead();
            }
            dispatchSelectionChangeEvent(oldNotif, newNotif);
         }
      }
      
      
      private function updateCounters() : void
      {
         _unreadNotifsTotal = 0;
         _newNotifsTotal = 0;
         for each (var notif:Notification in source)
         {
            if ( !notif.read )
            {
               _unreadNotifsTotal++;
            }
            if ( notif.isNew )
            {
               _newNotifsTotal++;
            }
         }
         dispatchCountersUpdatedEvent();
      }
      
      
      /* ################################## */
      /* ### EVENTS DISPATCHING METHODS ### */
      /* ################################## */
      
      
      private function dispatchSelectionChangeEvent(oldNotif:Notification, newNotif:Notification) : void
      {
         dispatchEvent(new NotificationsCollectionEvent(
            NotificationsCollectionEvent.SELECTION_CHANGE,
            oldNotif, newNotif
         ));
      }
      
      
      private function dispatchCountersUpdatedEvent() : void
      {
         dispatchEvent(new NotificationsCollectionEvent(
            NotificationsCollectionEvent.COUNTERS_UPDATED
         ));
      }
      
      
      /* ############################ */
      /* ### ITEM EVENTS HANDLERS ### */
      /* ############################ */
      
      
      private function registerNotifEventHandlers(notif:Notification) : void
      {
         notif.addEventListener(
            NotificationEvent.READ_CHANGE,
            notif_changeHandler, false, 1000
         );
         notif.addEventListener(
            NotificationEvent.ISNEW_CHANGE,
            notif_changeHandler, false, 1000
         );
      }
      
      
      private function removeNotifEventHandlers(notif:Notification) : void
      {
         notif.removeEventListener(NotificationEvent.READ_CHANGE, notif_changeHandler);
         notif.removeEventListener(NotificationEvent.ISNEW_CHANGE, notif_changeHandler);
      }
      
      
      private function notif_changeHandler(event:NotificationEvent) : void
      {
         updateCounters();
      }
      
      
      /* ############################ */
      /* ### SELF EVENTS HANDLERS ### */
      /* ############################ */
      
      
      private function registerSelfEventHandlers() : void
      {
         addEventListener(
            CollectionEvent.COLLECTION_CHANGE,
            this_collectionChangeHandler, false, 1000
         );
      }
      
      
      private function this_collectionChangeHandler(event:CollectionEvent) : void
      {
         if (event.kind != CollectionEventKind.REFRESH)
         {
            updateCounters();
            refresh();
         }
      }
   }
}