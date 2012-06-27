/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 6/27/12
 * Time: 4:56 PM
 * To change this template use File | Settings | File Templates.
 */
package models.notification {
   import flash.display.BitmapData;

   import utils.assets.AssetNames;

   public class MSuccessEvent extends MTimedEvent {
      public function MSuccessEvent(_message: String, _clickHandler: Function = null) {
         super(_message, _clickHandler);
      }

      [Bindable(event="WillNotChange")]
      override public function get rendererAlpha(): Number {
         return INACTIVE_CONTENT_ALPHA;
      }

      public override function get image(): BitmapData
      {
         return IMG.getImage(AssetNames.EVENTS_IMAGE_FOLDER + 'alert');
      }
   }
}
