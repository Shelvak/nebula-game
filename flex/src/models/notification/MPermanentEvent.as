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

   public class MPermanentEvent extends MEvent {

      private static const DURATION: int = 3000;

      public var notif: Notification;

      private var defaultClickHandler: Function;

      public function MPermanentEvent(_message: String, _clickHandler: Function = null) {
            super(_message, 0, !PlayerOptions.showInfoEvents);
            defaultClickHandler = _clickHandler;
      }

      public override function get image(): BitmapData
      {
         return IMG.getImage(AssetNames.EVENTS_IMAGE_FOLDER + 'info');
      }

      public override function clickHandler(event: MouseEvent): void {
         if (defaultClickHandler != null)
         {
            defaultClickHandler();
         }
      }
   }
}

