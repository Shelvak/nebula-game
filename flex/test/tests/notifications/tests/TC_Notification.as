package tests.notifications.tests
{
   import com.developmentarc.core.utils.EventBroker;
   
   import controllers.notifications.NotificationsCommand;
   
   import ext.hamcrest.events.causesTarget;
   
   import models.notification.Notification;
   import models.notification.events.NotificationEvent;
   import models.notification.parts.NotEnoughResources;
   
   import org.hamcrest.assertThat;
   import org.hamcrest.collection.hasItem;
   import org.hamcrest.object.hasProperties;
   import org.hamcrest.object.instanceOf;
   import org.hamcrest.object.notNullValue;
   
   import tests.notifications.Data;
   
   import utils.Objects;

   public class TC_Notification
   {		
      private var notif:Notification;
      
      
      [Before]
      public function setUp() : void
      {
         notif = new Notification();
      };
      
      
      [After]
      public function tearDown() : void
      {
         EventBroker.clearAllSubscriptions();
      };
      
      
      [Test(async, timeout=20, description="checks if READ_CHANGE event is dispached")]
      public function readChangeEvent() : void
      {
         notif.read = false;
         notif.addEventListener(NotificationEvent.READ_CHANGE, asyncHandler(eventHandler_empty, 10));
         notif.read = true;
      };
      
      
      [Test(async, timeout=20, description="checks if STARRED_CHANGE event is dispatched")]
      public function starredChangeEvent() : void
      {
         notif.starred = false;
         notif.addEventListener(NotificationEvent.STARRED_CHANGE, asyncHandler(eventHandler_empty, 10));
         notif.starred = true;
      };
      
      
      [Test(async, timeout=20, description="checks if ISNEW_CHANGE event is dispatched")]
      public function isNewChangeEvent() : void
      {
         notif.isNew = false;
         notif.addEventListener(NotificationEvent.IS_NEW_CHANGE, asyncHandler(eventHandler_empty, 10));
         notif.isNew = true;
      };
      
      
      [Test(description="Checks if afterModelCreate() works and part instance is instantiated")]
      public function customPartInstantiation() : void
      {
         notif = Objects.create(Notification, Data.notifOne);
         assertThat( notif.customPart, notNullValue() );
         assertThat( notif.customPart, instanceOf (NotEnoughResources) );
      };
      
      
      [Test(async, timeout=100, description="Checks if doRead() dispatches correct command with correct parameters")]
      public function doRead() : void
      {
         EventBroker.subscribe(NotificationsCommand.READ, asyncHandler(
            function(cmd:NotificationsCommand, passThroughData:Object) : void
            {
               assertThat( cmd.parameters.notifications, hasItem (notif) );
            },
            50, null
         ));
         notif.doRead();
      };
      
      
      [Test(async, timeout=100, description="Checks if doRead() does not dispath NotificationCommand when read = true")]
      public function doRead_alreadyRead() : void
      {
         EventBroker.subscribe(NotificationsCommand.READ, asyncHandler_eventDispatchedFails(20));
         notif.read = true;
         notif.doRead();
      };
      
      
      [Test(async, timeout=100, dexcription="Checks if doStar() dispatches correct command with correct parameters")]
      public function doStar() : void
      {
         EventBroker.subscribe(NotificationsCommand.STAR, asyncHandler(
            function(cmd:NotificationsCommand, passThroughData:Object) : void
            {
               assertThat( cmd.parameters, hasProperties({
                  "notification": notif,
                  "mark": true
               }));
            },
            50, null
         ));
         notif.doStar(true);
      };
      
      
      [Test(async, timeout=100, description="Checks if doStart() does not dispatch command if mark = starred")]
      public function doStar_markEqualsStarred() : void
      {
         EventBroker.subscribe(NotificationsCommand.STAR, asyncHandler_eventDispatchedFails(50));
         notif.starred = false;
         notif.doStar(false);
      };
      
      
      [Test]
      public function should_become_old_when_read() : void
      {
         // preconditions
         notif.read = false;
         notif.isNew = true;
         
         // test
         notif.read = true;
         assertThat( notif, hasProperties ({
            "read": true,
            "isNew": false
         }));
      }
      
      
      [Test]
      public function messageChangeEventWhenLocationIsUpdated() : void {
         notif = Objects.create(Notification, Data.notifOne);
         assertThat(
            "updating location", function():void{ notif.updateLocationName(2, "name") },
            causesTarget(notif) .toDispatchEvent (NotificationEvent.MESSAGE_CHANGE)
         );
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      include "../../asyncHelpers.as";
   }
}
