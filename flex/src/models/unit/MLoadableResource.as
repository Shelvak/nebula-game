/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 6/28/12
 * Time: 2:33 PM
 * To change this template use File | Settings | File Templates.
 */
package models.unit {
   import flash.display.BitmapData;

   import utils.assets.AssetNames;

   import utils.assets.ImagePreloader;

   public class MLoadableResource extends MLoadable {
      private var resourceType: String;
      public function MLoadableResource(type: String) {
         super();
         resourceType = type;
      }

      public override function get image(): BitmapData
      {
         return ImagePreloader.getInstance().getImage(
                   AssetNames.UI_IMAGES_FOLDER + resourceType + '_large');
      }
   }
}
