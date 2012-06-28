/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 6/28/12
 * Time: 2:32 PM
 * To change this template use File | Settings | File Templates.
 */
package models.unit {
   import flash.display.BitmapData;

   import utils.assets.AssetNames;

   import utils.assets.ImagePreloader;

   public class MLoadableAllResources extends MLoadable {
      public function MLoadableAllResources() {
      }

      public override function get label(): String
      {
         return null;
      }

      public override function get image(): BitmapData
      {
         return ImagePreloader.getInstance().getImage(
                AssetNames.UI_IMAGES_FOLDER + 'all_resources_large');
      }
   }
}
