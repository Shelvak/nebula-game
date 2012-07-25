/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 6/28/12
 * Time: 2:23 PM
 * To change this template use File | Settings | File Templates.
 */
package models.unit {
   import config.Config;

   import flash.display.BitmapData;
   import flash.events.MouseEvent;

   import utils.assets.AssetNames;

   import utils.assets.ImagePreloader;
   import utils.locale.Localizer;

   public class MLoadableAllUnits extends MLoadable {
      public function MLoadableAllUnits() {
      }

      public override function get label(): String
      {
         return Localizer.string('Units', 'label.allUnits');
      }

      public override function get image(): BitmapData
      {
         return ImagePreloader.getInstance().getImage(
                AssetNames.UI_IMAGES_FOLDER + 'all_units_large');
      }

      public override function clickHandler(e: MouseEvent): void {
         AL.transferAllUnits();
      }

      public function set anyUnitEnabled(value: Boolean): void
      {
         _anyUnitEnabled = value;
         dispatchCountChangeEvent();
      }

      private var _anyUnitEnabled: Boolean;

      [Bindable(event="loadableCountChange")]
      override public function get enabled(): Boolean {
         return super.enabled && (maxVolume == PLANET_STORAGE
            ? true
            : _anyUnitEnabled);
      }
   }
}
