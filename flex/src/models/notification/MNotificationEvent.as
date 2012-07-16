/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 6/21/12
 * Time: 12:26 PM
 * To change this template use File | Settings | File Templates.
 */
package models.notification {
   import flash.display.BitmapData;
   import flash.events.MouseEvent;

   import models.player.PlayerOptions;

   import utils.assets.AssetNames;

   public class MNotificationEvent extends MEvent {

      public var notif: Notification;

      public function MNotificationEvent(_notif: Notification) {
         super(_notif.message, PlayerOptions.notificationEventTime * 1000);
         notif = _notif;
      }

      public override function get image(): BitmapData
      {
         return IMG.getImage(AssetNames.EVENTS_IMAGE_FOLDER + 'notification');
      }

      public override function clickHandler(event: MouseEvent): void {
         ML.notifications.show(notif.id);
      }
   }
}
