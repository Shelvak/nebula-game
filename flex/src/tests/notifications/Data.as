package tests.notifications
{
   import flash.events.Event;
   
   import models.BaseModel;
   import models.location.LocationType;
   import models.notification.Notification;
   import models.notification.NotificationType;
   import models.notification.NotificationsCollection;

   public class Data
   {
      /**
       * <pre>
       * id: 1
       * event: NotificationType.NOT_ENOUGH_RESOURCES
       * starred: false
       * read: false
       * createdAt: 2010/05/01 10:00:00 +0300
       * expiresAt: 2010/05/01 18:00:00 +0300
       * planet.id: 2
       * planet.name: G12-SS16-P2
       * planet.solarSystemId: 16
       * constructable.type: Mothership
       * </pre>
       */
      public static function get notifOne() : Object
      {
         return {
               "id": 1, "event": NotificationType.NOT_ENOUGH_RESOURCES,
               "starred": false, "read": false,
               "createdAt": "2010-05-01T10:00:00+03:00",
               "expiresAt": "2010-05-01T18:00:00+03:00",
               "params": {
                  "planet": {
                     "id": 2,
                     "name": "G12-SS16-P2",
                     "solarSystemId": 16
                  },
                  "constructable": {"type": "Mothership"}
               }
         };
      }
      
      
      /**
       * <pre>
       * id: 2
       * event: NotificationType.NOT_ENOUGH_RESOURCES
       * starred: false
       * read: false
       * createdAt: 2010/04/01 10:00:00 +0300
       * expiresAt: 2010/04/01 18:00:00 +0300
       * </pre>
       */
      public static function get notifTwo() : Object
      {
         return {
               "id": 2, "event": NotificationType.NOT_ENOUGH_RESOURCES,
               "starred": false, "read": false,
               "createdAt": "2010-04-01T10:00:00+03:00",
               "expiresAt": "2010-04-01T18:00:00+03:00",
               "params": {
                  "planet": {
                     "id": 1,
                     "name": "G12-SS16-P1",
                     "solarSystemId": 16
                  },
                  "constructable": {"type": "Mothership"}
               }
         };
      }
      
      
      /**
       * 5 notifications (ordered (descending) by <code>read</code> (false > true) then
       * by <code>createdAt</code>):
       * <ul>
       *    <li>first two: <code>read = false, starred = false</code></li>
       *    <li>third and last: <code>read = true, starred = true</code></li>
       *    <li>fourth: <code>read = true, starred = false</code></li>
       * </ul>
       * This getter returns generic objects that represent notifications
       */
      public static function get notificationsRaw() : Array
      {
         var event:int = NotificationType.NOT_ENOUGH_RESOURCES;
         return [
            notifOne,
            notifTwo,
            {
               "id": 3, "event": event, "starred": true, "read": true,
               "createdAt": "2010-08-01T10:00:00+03:00",
               "expiresAt": "2010-08-01T18:00:00+03:00",
               "params": {
                  "planet": {
                     "id": 4,
                     "name": "G12-SS17-P4",
                     "solarSystemId": 17
                  },
                  "constructable": {"type": "Mothership"}
               }
            },
            {
               "id": 4, "event": event, "starred": false, "read": true,
               "createdAt": "2010-07-01T10:00:00+03:00",
               "expiresAt": "2010-07-01T18:00:00+03:00",
               "params": {
                  "planet": {
                     "id": 4,
                     "name": "G12-SS17-P4",
                     "solarSystemId": 17
                  },
                  "constructable": {"type": "Mothership"}
               }
            },
            {
               "id": 5, "event": event, "starred": true, "read": true,
               "createdAt": "2010-06-01T10:00:00+03:00",
               "expiresAt": "2010-06-01T18:00:00+03:00",
               "params": {
                  "planet": {
                     "id": 4,
                     "name": "G12-SS17-P4",
                     "solarSystemId": 17
                  },
                  "constructable": {"type": "Mothership"}
               }
            }
         ];
      }
      
      
      /**
       * <pre>
       * {
       * &nbsp;&nbsp;planet: {id: 2, name: G12-SS16-P2, solarSystemId: 16},
       * &nbsp;&nbsp;constructable: {type: Mothership}
       * }
       * </pre> 
       */      
      public static function get partNotEnoughResources() : Object
      {
         return {
            "location": {"type": LocationType.SS_OBJECT,"id": 2, "name": "G12-SS16-P2", "solarSystemId": 16},
            "constructables": {
               "Mothership": 1,
               "Trooper": 5
            }
         }
      }
      
      
      /**
       * <pre>
       * {
       * &nbsp;&nbsp;planet: {id: 4, name: G12-SS18-P4, solarSystemId: 18},
       * &nbsp;&nbsp;buildings: {
       * &nbsp;&nbsp;&nbsp;&nbsp;Mothership: 1
       * &nbsp;&nbsp;&nbsp;&nbsp;Barracks: 2
       * &nbsp;&nbsp;}
       * }
       * </pre> 
       */
      public static function get partBuildingsDeactivated() : Object
      {
         return {
            "location": {"id": 4, "name": "G12-SS18-P4", "solarSystemId": 18},
            "buildings": {
               "Mothership": 1,
               "Barracks": 2
            }
         };
      }
      
      
      /**
       * Collection of <code>Notification</code> objects.
       * 
       * @see Data#notificationsRaw
       */
      public static function get notificationsTyped() : NotificationsCollection
      {
         return BaseModel.createCollection(NotificationsCollection, Notification, notificationsRaw);
      }
   }
}