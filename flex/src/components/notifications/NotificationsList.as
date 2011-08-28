package components.notifications
{
   import controllers.navigation.MCMainArea;
   import controllers.screens.MainAreaScreens;
   
   import flash.events.MouseEvent;
   
   import models.events.ScreensSwitchEvent;
   import models.notification.Notification;
   import models.notification.NotificationsCollection;
   import models.notification.events.NotificationsCollectionEvent;
   
   import mx.collections.IList;
   import mx.core.ClassFactory;
   import mx.core.IVisualElement;
   import mx.events.FlexEvent;
   
   import spark.components.IItemRenderer;
   import spark.components.List;
   import spark.events.RendererExistenceEvent;
   
   /**
    * Lists specializes in displaying notifications.
    */
   public class NotificationsList extends List
   {
      public function NotificationsList()
      {
         super();
         useVirtualLayout = false;
         itemRenderer = new ClassFactory(IRNotification);
         addSelfEventHandlers();
         MA.addEventListener(ScreensSwitchEvent.SCREEN_CHANGING, removeNewStates);
      }
      
      private var MA: MCMainArea = MCMainArea.getInstance();
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      private function removeNewStates(e: ScreensSwitchEvent): void
      {
         if (MA.currentName == MainAreaScreens.NOTIFICATIONS)
         {
            notifs.removeFilter();
            for each (var newNotif: Notification in notifs)
            {
               if (newNotif.isNew)
               {
                  newNotif.isNew = false;
               }
            }
         }
      }
      
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
            notifs.select(notif.id, false);
         }
         else
         {
            notifs.deselect(false);
         }
      }
      
      
      /* ###################### */
      /* ### EVENT HANDLERS ### */
      /* ###################### */
      
      protected override function item_mouseDownHandler(event:MouseEvent):void
      {
      }
      
      override protected function partAdded(partName:String, instance:Object):void
      {
         super.partAdded(partName, instance);
         
         if (instance == dataGroup)
         {
            dataGroup.addEventListener(
               RendererExistenceEvent.RENDERER_ADD, dataGroup_addClickHandler);
            dataGroup.addEventListener(
               RendererExistenceEvent.RENDERER_REMOVE, dataGroup_removeClickHandler);
         }
      }
      
      private function dataGroup_addClickHandler(event:RendererExistenceEvent):void
      {
         var renderer:IVisualElement = event.renderer;
         if (!renderer)
            return;
         renderer.addEventListener(MouseEvent.CLICK, itemClicked);
      }
      
      private function dataGroup_removeClickHandler(event:RendererExistenceEvent):void
      {
         var renderer:Object = event.renderer;
         if (!renderer)
            return;
         renderer.removeEventListener(MouseEvent.CLICK, itemClicked);
      }
      
      protected function itemClicked(event: MouseEvent): void
      {// Handle the fixup of selection
         var newIndex:int
         if (event.currentTarget is IItemRenderer)
            newIndex = IItemRenderer(event.currentTarget).itemIndex;
         else
            newIndex = dataGroup.getElementIndex(event.currentTarget as IVisualElement);
         
         // Single selection case, set the selectedIndex 
         var currentRenderer:IItemRenderer;
         if (caretIndex >= 0)
         {
            currentRenderer = dataGroup.getElementAt(caretIndex) as IItemRenderer;
            if (currentRenderer)
               currentRenderer.showsCaret = false;
         }
         
         selectedIndex = newIndex;
         validateProperties();
      }
      
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