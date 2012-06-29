/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 6/21/12
 * Time: 11:52 AM
 * To change this template use File | Settings | File Templates.
 */
package controllers.notifications {
   import models.notification.MEvent;
   import models.notification.MNotificationEvent;

   import mx.collections.ArrayCollection;

   import utils.SingletonFactory;

   public class EventsController {

      /* don't add or remove events directly, use addEvent and removeEvent instead */
      public const events: ArrayCollection = new ArrayCollection();

      /* 'id': eventInstance */
      public var eventsHash: Object = {};

      private var lastId: int = 0;

      public static function getInstance(): EventsController
      {
         return SingletonFactory.getSingletonInstance(EventsController);
      }

      public function removeEventById(_id: int): void
      {
         if (eventsHash[_id] != null)
         {
            var idx: int = events.getItemIndex(eventsHash[_id]);
            events.removeItemAt(idx);
            eventsHash[_id] = null;
         }
      }

      public function removeEvent(_event: MEvent): void
      {
         eventsHash[_event.id] = null;
         var idx: int = events.getItemIndex(_event);
         events.removeItemAt(idx);
      }

      public function removeNotificationEvent(notificationId: int): void
      {
         for each (var _event: MEvent in events)
         {
            if (_event is MNotificationEvent &&
                  MNotificationEvent(_event).notif.id == notificationId)
            {
               removeEvent(_event);
               break;
            }
         }
      }

      public function addEvent(_event: MEvent): int
      {
         lastId++;
         eventsHash[lastId] = _event;
         events.addItem(_event);
         return lastId;
      }
   }
}
