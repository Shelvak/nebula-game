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

   import utils.assets.AssetNames;

   public class MPermanentEvent extends MEvent {

      private static const DURATION: int = 3000;

      public var notif: Notification;

      private var defaultClickHandler: Function;

      public function MPermanentEvent(_message: String, _clickHandler: Function = null) {
         super(_message);
         defaultClickHandler = _clickHandler;
      }

      public override function get image(): BitmapData
      {
         return IMG.getImage(AssetNames.EVENTS_IMAGE_FOLDER + 'info');
      }

      [Bindable(event="WillNotChange")]
      override public function get rendererAlpha(): Number {
         return 0.6;
      }

      public override function clickHandler(event: MouseEvent): void {
         if (defaultClickHandler != null)
         {
            defaultClickHandler();
         }
      }
   }
}

