/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 6/28/12
 * Time: 2:23 PM
 * To change this template use File | Settings | File Templates.
 */
package models.unit {
   import flash.display.BitmapData;

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
   }
}
