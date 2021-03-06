/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 6/28/12
 * Time: 2:32 PM
 * To change this template use File | Settings | File Templates.
 */
package models.unit {
   import flash.display.BitmapData;
   import flash.events.MouseEvent;

   import utils.assets.AssetNames;

   import utils.assets.ImagePreloader;

   public class MLoadableAllResources extends MLoadable {
      public function MLoadableAllResources() {
      }

      public override function get label(): String
      {
         return null;
      }

      public function set anyResourceEnabled(value: Boolean): void
      {
         _anyResourceEnabled = value;
         dispatchCountChangeEvent();
      }

      private var _anyResourceEnabled: Boolean;

      [Bindable(event="loadableCountChange")]
      override public function get enabled(): Boolean {
         return _anyResourceEnabled;
      }

      public override function get image(): BitmapData
      {
         return ImagePreloader.getInstance().getImage(
                AssetNames.UI_IMAGES_FOLDER + 'all_resources_large');
      }

      public override function clickHandler(e: MouseEvent): void {
         AL.transferAllResources();
      }
   }
}
