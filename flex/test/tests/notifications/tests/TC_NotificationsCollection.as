package tests.notifications.tests
{
   import com.developmentarc.core.utils.EventBroker;
   
   import controllers.CommunicationCommand;
   import controllers.notifications.NotificationsCommand;
   
   import models.BaseModel;
   import models.notification.Notification;
   import models.notification.NotificationType;
   import models.notification.NotificationsCollection;
   import models.notification.events.NotificationsCollectionEvent;
   
   import mx.events.CollectionEvent;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.hasItems;
   import org.hamcrest.object.equalTo;
   import org.hamcrest.object.hasProperties;
   import org.hamcrest.object.notNullValue;
   import org.hamcrest.object.nullValue;
   
   import tests.notifications.Data;

   public class TC_NotificationsCollection
   {
      private var collection:NotificationsCollection;
      
      
      [Before]
      public function setUp() : void
      {
         collection = new NotificationsCollection();
      }
      
      
      [After]
      public function tearDown() : void
      {
         EventBroker.clearAllSubscriptions();
         collection.removeAll();
         collection = null;
      }
      
      
      [Test(description="ensures that [class NotificationsCollection] has correct initial properties values")]
      public function initialState() : void
      {
         assertThat(
            collection, hasProperties({
               "notifsTotal": 0,
               "hasNotifs": false,
               "newNotifsTotal": 0,
               "hasNewNotifs": false,
               "unreadNotifsTotal": 0,
               "hasUnreadNotifs": false,
               "selectedNotif": null
            })
         );
      };
      
      
      [Test(description="checks if [prop notifsTotal] is updated when notifications are added and removed")]
      public function notifsTotal() : void
      {
         collection.addItem(new Notification());
         assertThat(
            collection, hasProperties({
               "hasNotifs": true,
               "notifsTotal": 1
            })
         );
         
         collection.addItem(new Notification());
         assertThat(
            collection, hasProperties({
               "hasNotifs": true,
               "notifsTotal": 2
            })
         );
         
         collection.removeAll();
         assertThat(
            collection, hasProperties({
               "hasNotifs": false,
               "notifsTotal": 0
            })
         );      
      };
      
      
      [Test(description="checks if [prop unreadNotifsTotal] is updated when notifications are added, removed or changed")]
      public function notifsUnreadTotal() : void
      {
         var idCounter:int = 1;
         function newNotif(read:Boolean) : Notification
         {
            return createNotif({
               "id": idCounter++, "read": read,
               "event": NotificationType.NOT_ENOUGH_RESOURCES, "starred": false,
               "createdAt": "2010-07-01T10:00:00+03:00", "expiresAt": "2010-07-01T18:00:00+03:00",
               "params": null
            });
         }
         
         collection.addItem(newNotif(false));
         assertThat(
            collection, hasProperties({
               "hasUnreadNotifs": true,
               "unreadNotifsTotal": 1
            })
         );
         
         collection.addItem(newNotif(false));
         collection.addItem(newNotif(false));
         collection.addItem(newNotif(false));
         assertThat(
            collection, hasProperties({
               "hasUnreadNotifs": true,
               "unreadNotifsTotal": 4
            })
         );
         
         collection.getNotifAt(0).read = true;
         assertThat( collection.unreadNotifsTotal, equalTo (3) );
         
         collection.removeItemAt(0);
         assertThat( collection.unreadNotifsTotal, equalTo (3) );
         
         collection.removeItemAt(0);
         assertThat( collection.unreadNotifsTotal, equalTo (2) );
         
         collection.removeAll();
         assertThat(
            collection, hasProperties({
               "hasUnreadNotifs": false,
               "unreadNotifsTotal": 0
            })
         );
      };
      
      
      [Test(description="checks if [prop newNotifsTotal] is updated when new notifications are added, removed or updated")]
      public function newNotifsTotal() : void
      {
         assertThat(
            collection, hasProperties({
               "hasNewNotifs": false,
               "newNotifsTotal": 0
            })
         );
         
         var idCounter:int = 1;
         function newNotif(isNew:Boolean) : Notification
         {
            return createNotif({
               "id": idCounter++, "read": false, "isNew": isNew,
               "event": NotificationType.NOT_ENOUGH_RESOURCES, "starred": false,
               "createdAt": "2010-07-01T10:00:00+03:00", "expiresAt": "2010-07-01T18:00:00+03:00",
               "params": null
            });
         };
         
         collection.addItem(newNotif(false));
         collection.addItem(newNotif(true));
         assertThat(
            collection, hasProperties({
               "hasNewNotifs": true,
               "newNotifsTotal": 1
            })
         );
         
         collection.addItem(newNotif(true));
         collection.addItem(newNotif(true));
         assertThat( collection.newNotifsTotal, equalTo(3) );
         
         collection.removeItemAt(3);
         assertThat( collection.newNotifsTotal, equalTo(3) );
         
         collection.removeItemAt(0);
         assertThat( collection.newNotifsTotal, equalTo(2) );
         
         collection.getNotifAt(0).isNew = false;
         assertThat( collection.newNotifsTotal, equalTo(1) );
         
         collection.removeAll();
         assertThat(
            collection, hasProperties({
               "hasNewNotifs": false,
               "newNotifsTotal": 0
            })
         );
      }
      
      
      [Test(description="checks if 'starred' filter works correctly")]
      public function applyStarredFilter() : void
      {
         collection.addAll(Data.notificationsTyped);
         
         collection.applyStarredFilter(true);
         // After applying filter counters should have not change their values
         assertThat( collection, hasProperties({
            "notifsTotal": 5,
            "newNotifsTotal": 0,
            "unreadNotifsTotal": 2
         }));
         // Now check items that were left out by the filter
         assertThat( collection, hasItems(
            hasProperties({"id": 3, "starred": true}),
            hasProperties({"id": 5, "starred": true})
         ));
         
         collection.applyStarredFilter(false);
         assertThat( collection, hasItems(
            hasProperties({"id": 1, "starred": false}),
            hasProperties({"id": 2, "starred": false}),
            hasProperties({"id": 4, "starred": false})
         ));
      };
      
      
      [Test(description="checks if 'read' filter works correctly")]
      public function applyReadFilter() : void
      {
         collection.addAll(Data.notificationsTyped);
         
         collection.applyReadFilter(true);
         // Counters should have not changed they values
         assertThat( collection, hasProperties({
            "notifsTotal": 5,
            "newNotifsTotal": 0,
            "unreadNotifsTotal": 2
         }));
         // Collection should have only 3 items
         assertThat( collection.length, equalTo (3) );
         assertThat( collection, hasItems(
            hasProperties ({"id": 3, "read": true}),
            hasProperties ({"id": 4, "read": true}),
            hasProperties ({"id": 5, "read": true})
         ));
         
         collection.applyReadFilter(false);
         // Collection should have only tow items
         assertThat( collection.length, equalTo (2) );
         assertThat( collection, hasItems(
            hasProperties ({"id": 1, "read": false}),
            hasProperties ({"id": 2, "read": false})
         ));
      }
      
      
      [Test(description="checks if removeFilter() works as expected")]
      public function removeFilter() : void
      {
         collection.addAll(Data.notificationsTyped);
         collection.applyStarredFilter(true);
         collection.removeFilter();
         assertThat( collection, hasItems(
            hasProperties({"id": 1, "starred": false}),
            hasProperties({"id": 2, "starred": false}),
            hasProperties({"id": 3, "starred": true})
         ));
      };
      
      
      [Test(description="Checks if selection works when no filters are applied")]
      public function selection_noFilters() : void
      {
         var readCommandDispatched:Boolean = false;
         EventBroker.subscribe(NotificationsCommand.READ,
            function(command:CommunicationCommand) : void
            {
               readCommandDispatched = true;
            }
         );
         var collectionEvent:NotificationsCollectionEvent = null;
         collection.addEventListener(NotificationsCollectionEvent.SELECTION_CHANGE,
            function(event:NotificationsCollectionEvent) : void
            {
               collectionEvent = event;
            }
         ); 
         collection.addAll(Data.notificationsTyped);
         
         // Nothing should be selected in the beginning
         assertThat( collection.selectedNotif, nullValue() );
         
         // Select first notification
         collection.select(1);
         // selectionChange event should have been dispatched
         assertThat( collectionEvent, notNullValue() );
         // selectedNotif should have been set
         assertThat( collection.selectedNotif, notNullValue() );
         assertThat( collection.selectedNotif.id, equalTo (1) );
         // READ command should have been dispatched
         assertThat( readCommandDispatched, equalTo (true) );
         // event object should hold selected notification
         // old notification should not have been set
         assertThat( collectionEvent, hasProperties({
            "newNotif": collection.selectedNotif,
            "oldNotif": null
         }));
         collectionEvent = null;
         readCommandDispatched = false;
         
         // Select the same notification
         collection.select(1);
         // selectionChange event should not have been dispatched
         assertThat( collectionEvent, nullValue() );
         // selectedNotif should still be the same
         assertThat( collection.selectedNotif, notNullValue() );
         assertThat( collection.selectedNotif.id, equalTo (1) );
         
         // Select another notification
         collection.select(3);
         // selectionChange event should have been dispatched
         assertThat( collectionEvent, notNullValue() );
         // selectedNotif should have been set to another Notification instance
         assertThat( collection.selectedNotif, notNullValue() );
         assertThat( collection.selectedNotif.id, equalTo (3) );
         // event object should have both - newNotif and oldNotif set
         assertThat( collectionEvent, hasProperties({
            "newNotif": collection.selectedNotif,
            "oldNotif": collection.find(1)
         }));
         collectionEvent = null;
         
         // Finally deselect selected notification
         collection.deselect();
         // selectionChange event should have been dispatched
         assertThat( collectionEvent, notNullValue() );
         // selectedNotif should now be null
         assertThat( collection.selectedNotif, nullValue() );
         // event object should have only oldNotif set
         assertThat( collectionEvent, hasProperties({
            "newNotif": null,
            "oldNotif": collection.find(3)
         }));
         collectionEvent = null;
         
         // Try deselection again
         collection.deselect();
         // selectionChange event should not have been dispatched
         assertThat( collectionEvent, nullValue() );
         // selectedNotif should not have been set
         assertThat( collection.selectedNotif, nullValue() );
      };
      
      
      [Test("Checks if selectedNotif property is [unset / left intact] when filter is applied or removed")]
      public function selection_withFilters() : void
      {
         collection.addAll(Data.notificationsTyped);
         
         // Select notification with id 2 (not starred)
         collection.select(2);
         assertThat( collection.selectedNotif.id, equalTo (2) );
         
         // Apply starred filter
         collection.applyStarredFilter(true);
         // notification should have been deselected
         assertThat( collection.selectedNotif, nullValue() );
         
         // Now select starred notification
         collection.select(3);
         assertThat( collection.selectedNotif.id, equalTo (3) );
         
         // Remove filter
         collection.removeFilter();
         // same notification should still be selected
         assertThat( collection.selectedNotif.id, equalTo (3) );
         
         // Select notification with id 2 (not starred)
         collection.select(2);
         assertThat( collection.selectedNotif.id, equalTo (2) );
         
         // Apply oposite starred filter
         collection.applyStarredFilter(false);
         // same notification should still be selected
         assertThat( collection.selectedNotif.id, equalTo (2) );
      };
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function createNotif(data:Object) : Notification
      {
         return BaseModel.createModel(Notification, data);
      }
   }
}