package models.notification
{
   import controllers.ui.NavigationController;
   
   import models.ModelsCollection;
   import models.notification.events.NotificationEvent;
   import models.notification.events.NotificationsCollectionEvent;
   
   import mx.collections.Sort;
   import mx.collections.SortField;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   
   
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
         if ((filterFunction != starPosFilter && starred) || (filterFunction != starNegFilter && !starred))
         {
//            deselect();
//            filterFunction = function(notif:Notification) : Boolean
//            {
//               return notif.starred == starred || selectedNotif == notif;
//            };
//            refresh();
            if (starred)
            {
               filterFunction = starPosFilter;
            }
            else
            {
               filterFunction = starNegFilter;
            }
            refresh();
            updateSelectionAfterFilter();
         }
//         else
//         {
//         }
      }
      
      private var starPosFilter: Function = function(notif:Notification) : Boolean
      {
         return notif.starred == true || selectedNotif == notif;
      }
      
      private var starNegFilter: Function = function(notif:Notification) : Boolean
      {
         return notif.starred == false || selectedNotif == notif;
      }
      
      
      public function applyReadFilter(read:Boolean) : void
      {
         if ((filterFunction != readPosFilter && read) || (filterFunction != readNegFilter && !read))
         {
//            deselect();
//            filterFunction = function(notif:Notification) : Boolean
//            {
//               return notif.read == read;
//            }
//            refresh();
            if (read)
            {
               filterFunction = readPosFilter;
            }
            else
            {
               filterFunction = readNegFilter;
            }
            refresh();
            updateSelectionAfterFilter();
         }
//         else
//         {
//         }
      }
      
      private var readPosFilter: Function = function(notif:Notification) : Boolean
      {
         return notif.read == true || selectedNotif == notif;
      }
      
      private var readNegFilter: Function = function(notif:Notification) : Boolean
      {
         return notif.read == false || selectedNotif == notif;
      }
      
      public function removeFilter() : void
      {
         filterFunction = null;
         refresh();
         updateSelectionAfterFilter();
      }
      
      
      public function removeSort() : void
      {
         sort = null;
         refresh();
      }
      
      
      public function select(id:int, dispatchUiCommand:Boolean = true) : void
      {
         var notif:Notification = find(id);
         if (!notif)
         {
            removeFilter();
            notif = find(id);
         }
         selectImpl(notif, dispatchUiCommand);
      }
      
      
      public function deselect(dispatchUiCommand:Boolean = true) : void
      {
         selectImpl(null, dispatchUiCommand);
      }
      
      
      /**
       * Navigates to notifications screen and selects notification with a given id.
       * 
       * @param id id on notification to select
       */
      public function show(id:int) : void
      {
         NavigationController.getInstance().showNotifications();
         select(id, true);
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function applyCreatedAtSort() : void
      {
         var sort:Sort = new Sort();
         sort.fields = [
            new SortField("createdAt", false, true),
            new SortField("id", false, true)
         ];
         this.sort = sort;
         refresh();
      }
      
      
      private function updateSelectionAfterFilter() : void
      {
         if (_selectedNotif && (filterFunction == starPosFilter && !_selectedNotif.starred ||
                                filterFunction == starNegFilter &&  _selectedNotif.starred ||
                                filterFunction == readPosFilter && !_selectedNotif.read ||
                                filterFunction == readPosFilter &&  _selectedNotif.read))
         {
            deselect(true);
         }
      }
      
      
      private function selectImpl(newNotif:Notification = null, dispatchUiCommand:Boolean = true) : void
      {
         var oldNotif:Notification = _selectedNotif;
         if (newNotif != oldNotif)
         {
            _selectedNotif = newNotif;
            if (_selectedNotif)
            {
               _selectedNotif.doRead();
            }
            if (dispatchUiCommand)
            {
               dispatchSelectionChangeEvent(oldNotif, newNotif);
            }
         }
      }
      
      
      public function updateCounters() : void
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
         if (hasEventListener(NotificationsCollectionEvent.SELECTION_CHANGE))
         {
            dispatchEvent(new NotificationsCollectionEvent(
               NotificationsCollectionEvent.SELECTION_CHANGE,
               oldNotif, newNotif
            ));
         }
      }
      
      
      private function dispatchCountersUpdatedEvent() : void
      {
         if (hasEventListener(NotificationsCollectionEvent.COUNTERS_UPDATED))
         {
            dispatchEvent(new NotificationsCollectionEvent(
               NotificationsCollectionEvent.COUNTERS_UPDATED
            ));
         }
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
         //         if (event.kind != CollectionEventKind.REFRESH)
         //         {
         updateCounters();
         //            refresh();
         //         }
      }
   }
}