/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 6/27/12
 * Time: 4:59 PM
 * To change this template use File | Settings | File Templates.
 */
package models.notification {
   import flash.display.BitmapData;

   import utils.assets.AssetNames;

   public class MFaultEvent extends MTimedEvent {
      public function MFaultEvent(_message: String, _clickHandler: Function = null) {
         super(_message, _clickHandler);
      }

      public override function get image(): BitmapData
      {
         return IMG.getImage(AssetNames.EVENTS_IMAGE_FOLDER + 'fault');
      }
   }
}
